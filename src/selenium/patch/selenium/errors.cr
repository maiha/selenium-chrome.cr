module Selenium
  class Error < Exception; end
  class Timeout < Error; end
  class CannotSelect < Error; end
end
