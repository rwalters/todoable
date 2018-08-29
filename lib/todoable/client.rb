require "json"
require "time"
require "todoable/adapters/rest_adapter"

module Todoable
  class Client
    extend Dry::Configurable

    setting :adapter, Todoable::Adapters::RestAdapter.new

    attr_reader :username, :password
    attr_reader :token, :expires_at
    attr_reader :base_uri

    def initialize(username: nil, password: nil)
      @username = username || Todoable.config.username
      @password = password || Todoable.config.password
      @base_uri =  Todoable.config.base_uri
    end

    def get(path:, params: {})
      request(method: :get, path: path, params: params)
    end

    def post(path:, params: {})
      request(method: :post, path: path, params: params)
    end

    def request(method:, path:, params: {})
      authenticate

      headers = default_headers
      headers[:authorization] = "Token token=\"#{token}\""

      execute(method: method, path: path, params: params, headers: headers)
    end

    private

    def authenticate
      check_auth!
    rescue Todoable::BaseError
      [nil, nil]
    end

    def authenticated?
      expires_at && std_time <= expires_at
    end

    def check_auth!
      return [token, expires_at] if authenticated?

      (@token, @expires_at) = request_tuple

      [token, expires_at]
    rescue StandardError => e
      raise Todoable::ClientException.new(e.message)
    end

    def request_tuple
      args = {}
      args[:method] = :post
      args[:path] = "/authenticate"
      args[:user] = username
      args[:password] = password
      args[:headers] = default_headers

      auth_tuple = execute(args)
      expires = auth_tuple[:expires_at]

      [auth_tuple[:token], Time.parse(expires).utc]
    end

    def execute(method:, path:, params: {}, headers:, **args)
      args ||= {}
      args[:method]   = method

      # Make sure we only have one '/' between 'api' and the path"
      url = base_uri.sub(/[\/\s]*$/, '')
      path = path.sub(/^[\/\s]*/, '')

      args[:url]      = "#{url}/#{path}"
      args[:payload]  = params.to_json
      args[:headers]  = headers

      self.class.config.adapter.call(args) do |response|
        process(response)
      end
    end

    def process(response)
      case response.code
      when 204 # No content response from DELETE
        true
      when 200, 201
        parse(response.body)
      when 401
        raise Todoable::Unauthorized
      when 404
        raise Todoable::NotFound
      when 422
        raise Todoable::UnprocessableEntity.new(parse(response.body))
      when 500
        raise Todoable::ServerError
      end
    end

    def parse(json)
      JSON.parse(json, symbolize_names: true)
    rescue JSON::JSONError
      json
    end

    def default_headers
      { content_type: :json, accept: :json }.dup
    end

    def std_time
      Time.now.utc
    end
  end
end
