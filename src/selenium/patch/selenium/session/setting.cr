class Selenium::Session
  class Setting
    property open_timeout    : Time::Span = 30.seconds
    property element_timeout : Time::Span = 10.seconds
    property wait_interval   : Time::Span = 1.second
  end

  property setting : Setting = Setting.new
end
    
