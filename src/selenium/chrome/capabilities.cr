module Selenium::Chrome
  # `capabilities` setting is derived from
  # - https://github.com/amberframework/garnet-spec
  CAPABILITIES = {
    browserName:              "chrome",
    version:                  "",
    platform:                 "ANY",
    javascriptEnabled:        true,
    takesScreenshot:          true,
    handlesAlerts:            true,
    databaseEnabled:          true,
    locationContextEnabled:   true,
    applicationCacheEnabled:  true,
    browserConnectionEnabled: true,
    cssSelectorsEnabled:      true,
    webStorageEnabled:        true,
    rotatable:                true,
    acceptSslCerts:           true,
    nativeEvents:             true,
    args:                     "--headless",
  }
end
