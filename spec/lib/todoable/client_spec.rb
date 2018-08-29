require "spec_helper"
require_relative "./adapters/test_adapter"

RSpec.describe Todoable::Client do
  Given(:client_class) { Todoable::Client }
  Given(:client) { client_class.new }


  context "defaults are set" do
    Then { client.username == Todoable.config.username }
    Then { client.password == Todoable.config.password }
    Then { client.base_uri == Todoable.config.base_uri }
  end

  context "defaults can be overridden" do
    Given(:client) { Todoable::Client.new(username: uname, password: pword) }
    Given(:uname)  { "test_user" }
    Given(:pword)  { "test_pword" }

    Then { client.username == uname }
    Then { client.password == pword }
  end

  context "calls out to the HTTP adapter" do
    Given(:adapter) { Todoable::Adapters::TestAdapter.new }
    Given(:client) do
      client_class.config.adapter = adapter
      client_class.new
    end

    context "with GET" do
      Given(:adapter) do
        Todoable::Adapters::TestAdapter.new(status: 201, body: get_response)
      end
      Given(:get_response) { "get response" }

      Then { client.get(path: "/foo") == get_response }
    end

    context "with POST" do
      Given(:adapter) do
        Todoable::Adapters::TestAdapter.new(status: 201, body: post_response)
      end
      Given(:post_response) { "post response" }

      Then { client.post(path: "/bar") == post_response }
    end
  end
end
