require "./chrome/**"

class Selenium::Chrome
  def initialize(driver : Webdriver? = nil, capabilities = CAPABILITIES)
    driver ||= Selenium::Webdriver.new
    @session = Selenium::Session.new(driver, capabilities)
  end

  forward_missing_to @session
end
