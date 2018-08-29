require "todoable/repository/items"
require "todoable/repository/lists"

module Todoable::Repository
  extend Dry::Configurable

  setting :client, Todoable::Client.new
end
