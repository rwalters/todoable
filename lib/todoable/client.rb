require "rest-client"
require "json"

module Todoable
  class Client
    attr_reader :username, :password
    attr_reader :token, :expires_at
    attr_reader :base_uri

    def initialize(username: nil, password: nil)
      @username = username || Todoable.config.username
      @password = password || Todoable.config.password
      @base_uri = password || Todoable.config.base_uri
    end

    private

    def execute(method:, path:, params: {})
      RestClient::Request
        .execute(
          method: method,
          url: uri,
          payload: params.to_json,
          headers: headers,
        ) do |response|
          process(response)
        end
    end

    def process(response)
      case response.status
      when 204 # response from DELETE
        true
      when 200..299
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
      JSON.parse(json, symbolize_name: true)
    rescue JSON::JSONError
      json
    end
  end
end
