module Todoable::Repository
  class Lists
    class << self
      def all
        client.get(path: "/lists")[:lists].map do |list_hash|
          Todoable::List.new(list_hash)
        end
      end

      def by_id(*ids)
        lists = ids.map do |id|
          self[id]
        end

        lists
      end

      def [](id)
        list_hash = client.get(path: "/lists/#{id}")
        item_hashes = list_hash.delete(:items)

        list = all.select{|l| l.id == id }.first
        list_hash[:id]    = list.id
        list_hash[:src]   = list.src
        list_hash[:items] = item_hashes.map do |item_hash|
          Todoable::Item.new(item_hash.merge(list_id: id))
        end

        Todoable::List.new(list_hash)
      end

      def create(name:)
        args = {path: "/lists"}
        args[:params] = { list: {name: name}}

        list_hash = client.post(args)

        Todoable::List.new(list_hash)
      end

      def update(id:, name:)
        args = {path: "/lists/#{id}"}
        args[:params] = { list: {name: name}}
        args[:method] = :patch

        client.request(args)

        self[id]
      end

      def delete(*lists)
        args = {method: :delete}

        lists.each do |list|
          args[:path] = "/lists/#{list.id}"
          client.request(args)
        end

        true
      rescue
        false
      end

      def client
        Todoable::Repository.config.client
      end
    end
  end
end
