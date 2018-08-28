module Todoable::Repository
  class Lists
    class << self
      def all
        # returns all Lists
      end

      def by_id(*ids)
        # For each id in ids, pull down that List
      end

      def [](id)
        # Get the List for that id
      end

      def create(name:)
        # Create a List with that name
      end

      def update(id:, name:)
        # Update id's List with the new name
      end

      def delete(*ids)
        # Delete the List for each id in ids
      end
    end
  end
end
