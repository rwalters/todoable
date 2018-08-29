module Todoable
  class Item < Entity
    attribute :id,          Types::Strict::String.meta(omittable: true)
    attribute :name,        Types::Strict::String
    attribute :finished_at, Types::JSON::Time.meta(omittable: true)
    attribute :src,         Types::Strict::String.meta(omittable: true)
    attribute :list_id,     Types::Strict::String.meta(omittable: true)

    def list
      return nil if list_id.nil?

      @item ||= Todoable::Repository::Lists[list_id]
    end

    def refetch
      list.refetch.items.select{|i| i.id == id}.first
    end

    def delete
      Todoable::Repository::Items.delete(self)
    end
  end
end
