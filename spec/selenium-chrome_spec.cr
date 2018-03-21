require "./spec_helper"

CURRENT_SESSION = Array(Selenium::Chrome).new

private def session
  if session = CURRENT_SESSION.first?
    return session
  else
    raise "no active sessions"
  end
end

describe Selenium::Chrome do
  it "#new" do
    driver = Selenium::Webdriver.new(host: "selenium")
    CURRENT_SESSION << Selenium::Chrome.new(driver)
  end

  it "#open" do
    session.open "https://github.com/maiha/selenium-chrome.cr"
    session.url.should eq("https://github.com/maiha/selenium-chrome.cr")
  end
  
  describe "#find(css:xxx)" do
    it "returns WebElement when found" do
      h1 = session.find(css: "article>h1")
      h1.text.should eq("selenium-chrome.cr")
    end

    it "raises ElementNotFound when not found" do
      expect_raises(Selenium::Chrome::ElementNotFound) do
        session.find(css: "article>h1>xxx")
      end
    end
  end

  it "#close" do
    session.close
  end
end
