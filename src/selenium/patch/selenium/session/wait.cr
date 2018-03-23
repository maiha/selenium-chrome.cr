require "./setting"

class Selenium::Session
  def wait(hint : String? = "wait", interval : Time::Span? = nil, timeout : Time::Span? = nil, &condition : -> T) forall T
    timeout  ||= setting.element_timeout
    interval ||= setting.wait_interval

    started_at = Time.now
    while true
      if condition.call
        logger.debug "OK: #{hint}"
        break
      end

      if started_at + timeout < Time.now
        raise Timeout.new("timeout: #{hint} (#{setting.element_timeout})")
      end
      logger.debug "NG: #{hint} (retry after #{setting.wait_interval})"
      sleep interval
    end
    return true
  end
end
