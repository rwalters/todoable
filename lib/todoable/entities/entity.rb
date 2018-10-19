require 'dry-struct'

module Todoable
  module Types
    include Dry::Types.module

    Id        = Types::Strict::String.meta(omittable: true)
    Name      = Types::Strict::String
    Src       = Types::Strict::String.meta(omittable: true)
    Time      = Types::JSON::Time.meta(omittable: true)
  end

  class Entity < Dry::Struct
    transform_keys(&:to_sym)
    input input.strict
  end

  require "todoable/entities/list"
end
