class Selenium::Chrome
  module Dsl
    ######################################################################
    ### Sessions
    def open(url : String)
      @session.url = url
    end

    def close
      @session.stop
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
        return find_element!(:css, css, parent)
      end

      # second, parse id where it may contains prefix 'id:' or 'css:'
      case id
      when /^id:(.*)/
        return find_element!(:id, $1, parent)
      when /^css:(.*)/
        return find_element!(:css, $1, parent)
      end

      # third, parse as id for the case of invoking `find(id: "xxx")`
      if id
        return find_element!(:id, id, parent)
      end
      
      # finally, we can't find any args about target
      raise ArgumentError.new("no element targets found")
    end

    # override `find_element` to raise `ElementNotFound` when missing
    def find_element!(by, selector, parent : WebElement? = nil) : WebElement
      url = parent ? "/element/#{ parent.id }/element" : "/element"
      value = post(url, {
        using: WebElement.locator_for(by),
        value: selector
      })

      case value
      when Hash
        item = value
        unless item["ELEMENT"]?
          identifier = item.keys.find(&.starts_with?("element-"))
          unless item[identifier]?
            raise ElementNotFound.new("#{by}:#{selector}")
          end
        end
      end
                
      WebElement.new(@session, value.as(Hash))
    end
  end

  include Dsl
end
