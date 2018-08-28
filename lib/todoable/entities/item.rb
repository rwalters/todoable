module Todoable
  class Item < Entity
    attribute :id,          Types::Strict::Integer.meta(omittable: true)
    attribute :name,        Types::Strict::String
    attribute :finished_at, Types::JSON::DateTime.meta(omittable: true)
    attribute :src,         Types::Strict::String
  end
end
