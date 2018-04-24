class Selenium::Session
  class Setting
    property open_timeout    : Time::Span = 30.seconds
    property element_timeout : Time::Span = 10.seconds
    property wait_interval   : Time::Span = 1.second

    property download_timeout  : Time::Span = 5.minutes
    property download_interval : Time::Span = 3.seconds
  end

  property setting : Setting = Setting.new
end
    
