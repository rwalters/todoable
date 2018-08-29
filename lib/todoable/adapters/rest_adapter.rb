require "rest-client"

module Todoable::Adapters
  class RestAdapter
    def call(**args)
      yield RestClient::Request.execute(args)
    end
  end
end
