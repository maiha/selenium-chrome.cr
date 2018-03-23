require "./chrome/**"

module Selenium::Chrome
  def self.new(driver : Webdriver? = nil, capabilities = CAPABILITIES, downloads_dir : String? = nil)
    driver ||= Selenium::Webdriver.new
    session = Selenium::Session.new(driver, capabilities)
    if dir = downloads_dir
      session.downloads_dir = dir
    end
    return session
  end
end
