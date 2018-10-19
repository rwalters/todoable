require "todoable/entities/item"

module Todoable
  class List < Entity
    attribute :id,    Types::Id
    attribute :name,  Types::Name
    attribute :src,   Types::Src

    attribute :items, Types::Strict::Array.of(Todoable::Item).default([])

    def refetch
      Todoable::Repository::Lists[id]
    end

    def delete
      Todoable::Repository::Lists.delete(self)
    end
  end
end
