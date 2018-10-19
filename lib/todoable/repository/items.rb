module Todoable::Repository
  class Items
    class << self
      def all
        raise Todoable::NotAccessibleError
      end

      def by_id(*ids)
        items = ids.map do |id|
          self[id]
        end

        items
      end

      def [](id)
        raise Todoable::NotAccessibleError
      end

      def create(list_id:, name:)
        args = {path: "/lists/#{list_id}/items"}
        args[:params] = { item: {name: name}}

        item_hash = client.post(args)

        Todoable::Item.new(item_hash.merge(list_id: list_id))
      end

      def finish(item)
        args = {path: "/lists/#{item.list_id}/items/#{item.id}/finish"}
        args[:method] = :put

        client.request(args)

        list = Todoable::Repository::Lists[item.list_id]
        list.items.detect{|i| i.id == item.id}
      end

      def update(**args)
        raise Todoable::NotAccessibleError
      end

      def delete(*items)
        args = {method: :delete}

        items.each do |item|
          args[:path] = "/lists/#{item.list_id}/items/#{item.id}"
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
