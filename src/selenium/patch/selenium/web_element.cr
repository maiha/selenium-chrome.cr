module Selenium
  class WebElement
    class NotFound < Exception; end

    def initialize(@session, item)
      if id = item["ELEMENT"]?
        # JsonWireProtocol (obsolete)
        @id = id.as_s
      else
        # W3C Webdriver
        identifier = item.keys.find(&.starts_with?("element-")) || raise NotFound.new("element-*")
        v = item[identifier]? || raise NotFound.new(identifier)
        @id = v.as_s
      end
    end

    ######################################################################
    ### Input Elements
    def select
      return self if selected?
      click
    end

    def selected? : Bool
      v = get("/selected")
      case v
      when Bool
        return v
      else
        raise Error.new("[BUG] expects Bool, but remote api('/selected') returns %s (%s)" % [v.class, v.inspect[0..60]])
      end
    end

    def value=(v)
      post("/clear")
      send_keys v
    end

    def value
      attribute("value")
    end

    def html : String
      attribute("innerHTML").to_s
    end
  end
end
