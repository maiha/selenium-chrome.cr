require "./setting"

class Selenium::Session
  def wait(hint : String? = "wait", &condition : -> T) forall T
    started_at = Time.now
    while true
      if condition.call
        logger.debug "OK: #{hint}"
        break
      end

      if started_at + setting.element_timeout < Time.now
        raise Error.new("timeout: #{hint} (#{setting.element_timeout})")
      end
      logger.debug "NG: #{hint} (retry after #{setting.wait_interval})"
      sleep setting.wait_interval
    end
    return true
  end
end
