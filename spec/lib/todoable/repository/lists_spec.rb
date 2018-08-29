require "spec_helper"

RSpec.describe Todoable::Repository::Lists do
  Given(:repo)    { Todoable::Repository::Lists }
  Given(:client)  { double }

  Given(:list) { Todoable::List.new(list_hash) }

  Given(:reduced_list_hash) do
    { :name=>"test", items: []}
  end

  Given(:list_hash) do
    {:name=>"test", :src=>"http://example.com/lists/UUID", :id=> "UUID" }
  end

  Given(:lists_array) do
    [list]
  end

  context "Query Methods" do
    context ".all" do
      Given!(:setup) do
        allow(client)
          .to receive(:get)
          .with(path: "/lists")
          .and_return({lists: [list_hash]})

        Todoable::Repository.config.client = client
      end

      When(:result) { repo.all }
      Then { result == lists_array }
    end

    context "using the ID" do
      Given!(:setup) do
        allow(client)
          .to receive(:get)
          .with(path: "/lists")
          .and_return({lists: [list_hash]})

        allow(client)
          .to receive(:get)
          .with(path: "/lists/#{list_hash[:id]}")
          .and_return(reduced_list_hash)

        Todoable::Repository.config.client = client
      end

      Given(:list_hash) do
        reduced_list_hash.merge({:src=>"http://example.com/lists/UUID", :id=> "UUID" })
      end

      context ".by_id" do
        When(:result) { repo.by_id(list_hash[:id], list_hash[:id]) }
        Then { result == [list, list] }
      end

      context ".[]" do
        When(:result) { repo[list_hash[:id]] }
        Then { result == list }
      end
    end
  end

  context "Mutation Methods" do
    Given!(:setup) do
      allow(client)
        .to receive(:post)
        .with(path: "/lists", params: {list: {name: new_name}})
        .and_return(list_hash)

      allow(client)
        .to receive(:request)
        .with(path: "/lists", params: {list: {name: new_name}})
        .and_return(list_hash)

      Todoable::Repository.config.client = client
    end

    Given(:list_hash) do
      {name: new_name, src: "http://example.com/lists/UUID2", id: "UUID2", items: []}
    end

    Given(:new_name) { "test_new_name" }

    context ".create" do
      When(:result) { repo.create(name: new_name) }
      Then { result == list }
    end

    context ".update" do
      Given!(:setup) do
        allow(client)
          .to receive(:get)
          .with(path: "/lists")
          .and_return({lists: [list_hash]})

        allow(client)
          .to receive(:get)
          .with(path: "/lists/#{list_hash[:id]}")
          .and_return(updated_list_hash)

        allow(client)
          .to receive(:request)
          .with(method: :patch, path: "/lists/#{list.id}", params: {list: {name: updated_name}})
          .and_return("#{updated_name} updated")

        Todoable::Repository.config.client = client
      end
      Given(:updated_name) { "update name" }
      Given(:updated_list_hash) { reduced_list_hash.merge(name: updated_name) }
      Given(:updated_list) { Todoable::List.new(updated_list_hash) }

      When(:result) { repo.update(id: list.id, name: updated_name) }
      Then { result == updated_list }
    end

    context ".delete" do
      Given!(:setup) do
        allow(client)
          .to receive(:request)
          .with(method: :delete, path: "/lists/#{list.id}")

        Todoable::Repository.config.client = client
      end

      When(:result) { repo.delete(list) }
      Then { result == true }
    end
  end
end
