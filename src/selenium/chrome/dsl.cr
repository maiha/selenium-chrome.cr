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
      find_element(by, selector, parent).send_keys(value)
    end

    def fill(target : String, value, parent : WebElement? = nil)
      find_element(target, parent).send_keys(value)
    end

    # def return(target : String, parent : WebElement? = nil)
    #   fill(target, Keys::RETURN, parent)
    # end

    def find_element(target : String, *args)
      case target
      when /^css:(.*)/
        find_element(:css, $1, *args)
      when /^id:(.*)/
        find_element(:id, $1, *args)
      else
        raise ArgumentError.new("find_element must start with 'css:' or 'id:', but got '#{target}'")
      end
    end
  end

  include Dsl
end
