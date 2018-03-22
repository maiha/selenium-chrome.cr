module Selenium
  class Session
    ######################################################################
    ### Sessions

    def open(url : String)
      self.url = url
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

    # def return(target : String, parent : WebElement? = nil)
    #   fill(target, Keys::RETURN, parent)
    # end

    def find(id : String? = nil, css : String? = nil, parent : WebElement? = nil) : WebElement
      if id && css
        raise ArgumentError.new("both 'css:' and 'id:' exist")
      end

      # first, parse css where no prefix exists
      if css
        return find_element(:css, css, parent)
      end

      # second, parse id where it may contains prefix 'id:' or 'css:'
      case id
      when /^id:(.*)/
        return find_element(:id, $1, parent)
      when /^css:(.*)/
        return find_element(:css, $1, parent)
      end

      # third, parse as id for the case of invoking `find(id: "xxx")`
      if id
        return find_element(:id, id, parent)
      end
      
      # finally, we can't find any args about target
      raise ArgumentError.new("no element targets found")
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
