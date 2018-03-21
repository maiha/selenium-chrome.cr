require "./chrome/**"

class Selenium::Chrome
  class ElementNotFound < Exception; end

  def initialize(driver : Webdriver? = nil, capabilities = CAPABILITIES)
    driver ||= Selenium::Webdriver.new
    @session = Selenium::Session.new(driver, capabilities)
  end

  forward_missing_to @session
end
