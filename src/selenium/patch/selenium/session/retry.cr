require "./setting"

class Selenium::Session
  protected def retry(hint : String? = nil, &block : -> T) forall T
    started_at = Time.now
    v : T? = nil
    while true
      begin
        v = block.call
        logger.debug "OK: #{hint}"
        break
      rescue err : WebElement::NotFound
        if started_at + @setting.element_timeout < Time.now
          raise err
        end
        logger.debug "NG: #{hint} #{err.class} (retry after #{@setting.element_wait_interval})"
        sleep setting.wait_interval
      end
    end
    return v.not_nil!

  rescue err
    logger.error err
    logger.error err.inspect_with_backtrace
    raise err
  end
end
