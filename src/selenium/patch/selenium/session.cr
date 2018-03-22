require "./session/*"

module Selenium
  class Session
    ######################################################################
    ### Sessions

    def open(url : String, strict = false)
      clue = "open: '#{url}'"
      started_at = Time.now
      logger.debug clue
      self.url = url

      while true
        current = self.url
        if current == url || !strict
          logger.info "[OK] #{clue}".colorize(:green)
          return current
        elsif started_at + setting.open_timeout < Time.now
          raise Error.new("timeout: #{clue} (#{setting.open_timeout})")
        else
          logger.debug "#{clue}: waiting '#{current}' becomes '#{url}' (retry after #{setting.wait_interval})".colorize(:yellow)
          sleep setting.wait_interval
        end
      end
    end

    def close
      stop
    end

    ######################################################################
    ### Syntax Sugar
    def id(*args)
      find_element(:id, *args)
    end

    def css(*args)
      find_elements(:css, *args)
    end

    def fill(by : Symbol, selector : String, value, parent : WebElement? = nil)
      find("#{by}:#{selector}", parent).send_keys(value)
    end

    def fill(target : String, value, parent : WebElement? = nil)
      find("#{target}", parent).send_keys(value)
    end

    # def return(target : String, parent : WebElement? = nil)
    #   fill(target, Keys::RETURN, parent)
    # end

    # `find` is a wrapper of `find_element` with accepting prefixed `css:` or `id:`
    # - `find(id: "foo")`  # invokes `find_element(:id, "foo")`
    # - `find(css: "foo")` # invokes `find_element(:css, "foo")`
    # - `find("foo")`      # same as `find(id: "foo")`
    # - `find("id:foo")`   # same as `find(id: "foo")`
    # - `find("css:foo")`  # same as `find(css: "foo")`
    def find(id : String? = nil, css : String? = nil, parent : WebElement? = nil) : WebElement
      clue = nil
      v : WebElement? = nil
      if id && css
        raise ArgumentError.new("both 'css:' and 'id:' exist")
      end

      # first, parse css where no prefix exists
      if css
        clue = "css:#{css}"
        v = find_element(:css, css, parent)
        return v
      end

      # second, parse id where it may contains prefix 'id:' or 'css:'
      case id
      when /^id:(.*)/
        clue = "id:#{$1}"
        v = find_element(:id, $1, parent)
        return v
      when /^css:(.*)/
        clue = "css:#{$1}"
        v = find_element(:css, $1, parent)
        return v
      end

      # third, parse as id for the case of invoking `find(id: "xxx")`
      if id
        clue = "id:#{id}"
        v = find_element(:id, id, parent)
        return v
      end
      
      # finally, we can't find any args about target
      raise ArgumentError.new("no element targets found")

    rescue WebElement::NotFound
      raise WebElement::NotFound.new(clue.to_s)

    ensure
      if v
        logger.debug("element found: '#{clue}'")
      else
        logger.error("[NG] element not found: '#{clue}'".colorize(:red))
      end
    end

    # `find?` acts same as `find` except it returns nil rather than raising error when the element is not found.
    def find?(*args, **opts)
      find(*args, **opts)
    rescue WebElement::NotFound
      nil
    end
    
    # extend `post` to handle errors
    protected def post(path, body = nil)
      response = driver.post("/session/#{ id }#{ path }", body)
      v = response["value"]

      case v
      when Hash
        # {"message" => "unknown error: session deleted because of page crash
        if msg = v["message"]?
          if msg.to_s =~ /^unknown error:/
            raise Error.new(msg.to_s)
          end
        end
      end

      return v
    end
  end
end
