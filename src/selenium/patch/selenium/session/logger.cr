require "./setting"

class Selenium::Session
  property logger : Logger = Logger.new(STDOUT)
end
