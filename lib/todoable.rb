require "time"
require "dry-configurable"

require "todoable/version"

module Todoable
  extend Dry::Configurable

  # If this was a real gem, we wouldn't provide defaults!
  setting :username, 'ray.walters@gmail.com'
  setting :password, 'todoable'
  setting :base_uri, 'http://todoable.teachable.tech/api/'

  require "todoable/errors"
  require "todoable/client"
  require "todoable/entities"
  require "todoable/repository"
end
