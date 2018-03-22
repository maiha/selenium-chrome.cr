require "spec"
require "../src/selenium-chrome"

def selenium_host : String
  ENV["SELENIUM_SERVER"]? || "localhost"
end

def selenium_port : Int32
  (ENV["SELENIUM_PORT"]? || 4444).to_i
end

def selenium_driver : Selenium::Webdriver
  Selenium::Webdriver.new(host: selenium_host, port: selenium_port)
end
