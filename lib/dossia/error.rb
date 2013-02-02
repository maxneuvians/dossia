module Dossia

  class Error               < StandardError; end
  class ConfigurationError  < Error; end
  class NotFoundError       < Error; end
  class ValidationError     < Error; end
  class UnauthorizedError   < Error; end

end