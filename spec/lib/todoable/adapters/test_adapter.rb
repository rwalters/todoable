require "json"

module Todoable::Adapters
  class TestAdapter
    attr_reader :response

    def initialize(status: nil, body: nil)
      @response = Response.new(status: status, body: body)
    end

    def auth_response
      Response.new(body: {token: "foo", expires_at: Time.now.utc.iso8601})
    end

    def call(**args)
      if args[:url] =~ /authenticate/
        yield auth_response
      else
        yield response
      end
    end

    class Response
      attr_reader :code, :body

      def initialize(status: nil, body: nil)
        @code = status || 200
        @body = (body || "test_response").to_json
      end
    end
  end
end
