require 'spec_helper'

RSpec.describe Todoable::Item do
  Given(:item) do
    Todoable::Item.new(name: name, src: src)
  end
  Given(:name) { "test item" }
  Given(:src)  { "http://www.example.com" }

  Then { item != nil }
  Then { item.name == name }
  Then { item.src == src }
end
