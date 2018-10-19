module Todoable
  class Item < Entity
    attribute :id,          Types::Id
    attribute :name,        Types::Name
    attribute :finished_at, Types::Time
    attribute :src,         Types::Src

    attribute :list_id,     Types::Id

    def list
      return nil if list_id.nil?

      @list ||= Todoable::Repository::Lists[list_id]
    end

    def refetch
      list.refetch.items.select{|i| i.id == id}.first
    end

    def delete
      Todoable::Repository::Items.delete(self)
    end
  end
end
