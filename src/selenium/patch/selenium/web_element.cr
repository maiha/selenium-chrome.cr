module Selenium
  class WebElement
    class NotFound < Exception; end

    def initialize(@session, item)
      if id = item["ELEMENT"]?
        # JsonWireProtocol (obsolete)
        @id = id.as(String)
      else
        # W3C Webdriver
        identifier = item.keys.find(&.starts_with?("element-")) || raise NotFound.new("element-*")
        v = item[identifier]? || raise NotFound.new(identifier)
        @id = v.as(String)
      end
    end

    ######################################################################
    ### Input Elements
    def selected? : Bool
      get("/selected").as(Bool)
    end

    def value=(v)
      post("/clear")
      send_keys v
    end

    def value
      attribute("value")
    end
  end
end
