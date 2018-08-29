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
        list_hash[:items] = item_hashes.map do |item_hash|
          Todoable::Item.new(item_hash)
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

      def delete(*ids)
        args = {method: :delete}

        ids.each do |id|
          args[:path] = "/lists/#{id}"
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
