require "./chrome/**"

module Selenium::Chrome
  def self.new(driver : Webdriver? = nil, capabilities = CAPABILITIES)
    driver ||= Selenium::Webdriver.new
    return Selenium::Session.new(driver, capabilities)
  end
end
