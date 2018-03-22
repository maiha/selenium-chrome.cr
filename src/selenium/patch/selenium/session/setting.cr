class Selenium::Session
  record Setting,
    open_timeout    : Time::Span = 30.seconds,
    element_timeout : Time::Span = 10.seconds,
    wait_interval   : Time::Span = 1.second
        
  property setting : Setting = Setting.new
end
    
