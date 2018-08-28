require "todoable/entities/item"

module Todoable
  class List < Entity
    attribute :id,    Types::Strict::Integer.meta(omittable: true)
    attribute :name,  Types::Strict::String
    attribute :src,   Types::Strict::String

    attribute :items, Types::Strict::Array.of(Todoable::Item).default([])
  end
end
