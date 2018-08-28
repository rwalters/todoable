module Todoable::Repository
  class Items
    class << self
      def all
        # Raise an exception
      end

      def by_id(*ids)
        # For each id in ids, pull down that Item
      end

      def [](id)
        # Get the Item for that id
      end

      def create(name:)
        # Create a Item with that name
      end

      def finish(id)
        # Finish the item with this id
      end

      def update(**args)
        # Raise an exception
      end

      def delete(*ids)
        # Delete the Item for each id in ids
      end
    end
  end
end
