module Todoable
  class BaseError < StandardError;end

  class ClientException < BaseError;end
  class Unauthorized < BaseError;end
  class NotFound < BaseError;end
  class UnprocessableEntity < BaseError;end
  class ServerError < BaseError;end
end
