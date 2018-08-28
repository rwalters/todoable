require 'spec_helper'

RSpec.context Todoable::List do
  Given(:list) do
    Todoable::List.new(name: name, src: src)
  end
  Given(:name) { "test list" }
  Given(:src)  { "http://www.example.com" }

  Then { list != nil }
  Then { list.name == name }
  Then { list.src == src }
end
