module Dossia

  class Error               < StandardError; end
  class BadRequestError     < Error; end
  class ConfigurationError  < Error; end
  class MethodError         < Error; end
  class NotFoundError       < Error; end
  class ValidationError     < Error; end
  class UnauthorizedError   < Error; end

end