require "spec_helper"

RSpec.describe Todoable::Repository::Items do
  Given(:repo)    { Todoable::Repository::Items }
  Given(:client)  { double }

  context "Query Methods" do
    context ".all" do
      When(:result) { repo.all }
      Then { result == Failure(Todoable::NotAccessibleError) }
    end

    context ".by_id" do
      When(:result) { repo.by_id("test") }
      Then { result == Failure(Todoable::NotAccessibleError) }
    end

    context ".[]" do
      When(:result) { repo["test"] }
      Then { result == Failure(Todoable::NotAccessibleError) }
    end
  end

  context "Mutation Methods" do
    Given(:item) { Todoable::Item.new(item_hash) }
    Given(:item_hash) do
      {list_id: list_id, :name=>"test", :src=>"http://example.com/lists/UUID", :id=> "Item_UUID" }
    end

    Given(:list) { Todoable::List.new(list_hash) }
    Given(:list_id) { "List_UUID" }
    Given(:list_hash) do
      {:name=>"test", :src=>"http://example.com/lists/UUID", :id=> list_id, items: [item_hash]}
    end

    Given!(:setup) do
      allow(client)
        .to receive(:get)
        .with(path: "/lists")
        .and_return({lists: [list_hash]})

      allow(client)
        .to receive(:post)
        .with(path: "/lists/#{list.id}/items", params: {item: {name: new_name}})
        .and_return(obj_hash)

      Todoable::Repository.config.client = client
    end

    Given(:obj_hash) do
      item_hash.merge(name: new_name)
    end

    Given(:new_name) { "test_new_name" }

    context ".create" do
      When(:result) { repo.create(list_id: list.id, name: new_name) }
      Then { result == Todoable::Item.new(obj_hash) }
    end

    context ".update" do
      When(:result) { repo.update(id: "test") }
      Then { result == Failure(Todoable::NotAccessibleError) }
    end

    context ".finish" do
      Given!(:setup) do
        allow(client)
          .to receive(:get)
          .with(path: "/lists")
          .and_return({lists: [list_hash]})

        allow(client)
          .to receive(:get)
          .with(path: "/lists/#{list.id}")
          .and_return(updated_list_hash)

        args = {method: :put}
        args[:path] = "/lists/#{list.id}/items/#{item.id}/finish"

        allow(client)
          .to receive(:request)
          .with(args)
          .and_return("#{updated_name} finished")

        Todoable::Repository.config.client = client
      end

      Given(:updated_list_hash) { list_hash.merge(items: [updated_item_hash]) }

      Given(:updated_name) { "update name" }
      Given(:updated_item_hash) { item_hash.merge(name: updated_name) }
      Given(:updated_item) { Todoable::Item.new(updated_item_hash) }

      When(:result) { repo.finish(item) }
      Then { result == updated_item }
    end

    context ".delete" do
      Given!(:setup) do
        allow(client)
          .to receive(:request)
          .with(method: :delete, path: "/lists/#{list.id}/items/#{item.id}")

        Todoable::Repository.config.client = client
      end

      When(:result) { repo.delete(item) }
      Then { result == true }
    end
  end
end
