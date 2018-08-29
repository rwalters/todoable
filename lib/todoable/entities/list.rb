require "todoable/entities/item"

module Todoable
  class List < Entity
    attribute :id,    Types::Strict::String.meta(omittable: true)
    attribute :name,  Types::Strict::String
    attribute :src,   Types::Strict::String.meta(omittable: true)

    attribute :items, Types::Strict::Array.of(Todoable::Item).default([])

    def refetch
      Todoable::Repository::Lists[id]
    end

    def delete
      Todoable::Repository::Lists.delete(self)
    end
  end
end
