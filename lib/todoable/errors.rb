module Todoable
  class BaseError < StandardError;end

  class ClientException < BaseError;end
  class Unauthorized < ClientException;end
  class NotFound < ClientException;end
  class UnprocessableEntity < ClientException;end
  class ServerError < ClientException;end

  class RepositoryException < BaseError;end
  class NotAccessibleError < RepositoryException;end
end
