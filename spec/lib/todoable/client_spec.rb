require 'spec_helper'

RSpec.context Todoable::Client do
  Given(:client) { Todoable::Client.new }

  Then "it exists" do
    client != nil
  end
end
