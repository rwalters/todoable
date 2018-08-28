require 'dry-struct'

module Todoable
  module Types
    include Dry::Types.module
  end

  class Entity < Dry::Struct
    transform_keys(&:to_sym)
    input input.strict
  end

  require "todoable/entities/list"
end
