require "./spec_helper"

CURRENT_SESSION = Array(Selenium::Session).new

private def session
  if session = CURRENT_SESSION[-1]?
    return session
  else
    raise "no active sessions"
  end
end

describe Selenium::Chrome do
  it "#new" do
    CURRENT_SESSION << Selenium::Chrome.new(selenium_driver)
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

    it "raises NotFound when not found" do
      expect_raises(Selenium::WebElement::NotFound) do
        session.find(css: "xxx")
      end
    end
  end

  describe "#find?(css:xxx)" do
    pending "returns WebElement when found" do
      h1 = session.find?(css: "article>h1")
      h1.text.should eq("selenium-chrome.cr")
    end

    pending "raises NotFound when not found" do
      session.find?(css: "article>h1>xxx").should eq(nil)
    end
  end
  
  it "#close" do
    session.close
  end
end
