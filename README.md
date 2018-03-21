# selenium-chrome.cr

A handy and thin wrapper for `selenium-webdriver-crystal`.

- crystal: 0.24.2

## Component

- Selenium Server
  - server: docker selenium/standalone-chrome-debug:3.11.0-bismuth
  - driver: chrome (bundled in above image)
- Selenium Client
  - driver: https://github.com/ysbaddaden/selenium-webdriver-crystal
  - helper: THIS REPOSITORY (provides handy accessors and dsl)
  - client: Please see "USAGE" and write as you like.

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  selenium-chrome:
    github: maiha/selenium-chrome.cr
    version: 0.1.0
```

## Usage

```crystal
require "selenium-chrome"

session = Selenium::Chrome.new
session.open "https://github.com/maiha/selenium-chrome.cr"
```

## Development

TODO: Write development instructions here

## Contributing

1. Fork it ( https://github.com/maiha/selenium-chrome.cr/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [maiha](https://github.com/maiha) maiha - creator, maintainer
