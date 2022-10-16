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
    s = Selenium::Chrome.new(selenium_driver)
    s.logger = Logger.new(nil)
    CURRENT_SESSION << s
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
    it "returns WebElement when found" do
      h1 = session.find?(css: "article>h1")
      h1.try(&.text).should eq("selenium-chrome.cr")
    end

    it "returns nil when not found" do
      session.find?(css: "article>h1>xxx").should eq(nil)
    end
  end

  describe "#find!(css:xxx)" do
    it "returns WebElement when found" do
      h1 = session.find!(css: "article>h1")
      h1.try(&.text).should eq("selenium-chrome.cr")
    end

    it "raises Selenium::Timeout error when not found" do
      session.setting.element_timeout = 1.second
      started_at = Time.local
      expect_raises(Selenium::Timeout) do
        session.find!(css: "article>h1>xxx")
      end
      (started_at + 1.second <= Time.local).should be_true
    end
  end

  describe "#fill(css:xxx, value)" do
    it "sets the value to the element, and returns the element" do
      e = session.fill("css:input[name='q']", "selenium")
      e.should be_a(Selenium::WebElement)
    end
  end

  describe "#wait(condition)" do
    it "waits until the condition becomes true" do
      session.setting.element_timeout = 1.second
      session.wait{ 1 == 1 }
    end

    it "raises timeout error when the condition doesn't be satisfied" do
      session.setting.element_timeout = 1.second
      expect_raises(Selenium::Error, /timeout/) do
        session.wait{ session.url == "/" }
      end
    end
  end

  describe Selenium::WebElement do
    describe "#value" do
      it "returns the value of the element" do
        session.find("css:input[name='q']").value.should eq("selenium")
      end
    end

    describe "#value=(v)" do
      it "sets the value to the element" do
        q = session.find("css:input[name='q']")
        q.value = "webdriver"
        q.value.should eq("webdriver")
      end
    end

    describe "#html" do
      # github frequently changes its design
      pending "returns the value of innerHTML" do
        p = session.find("css:#readme > div.Box-body.p-6 > article > p:nth-child(2)")
        p.html.should eq("A handy and thin wrapper for <code>selenium-webdriver-crystal</code>.")
      end
    end
  end
  
  describe "#download" do
    pending "returns downloaded file as Bytes" do
    end

    it "raises timeout error when no files are downloaded" do
      expect_raises(Selenium::Timeout) do
        session.download(timeout: 1.second, ext: "foo") do
          session.find("css:input[name='q']")
        end
      end
    end
  end

  it "#close" do
    session.close
  end
end
