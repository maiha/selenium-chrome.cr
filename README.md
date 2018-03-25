# selenium-chrome.cr [![Build Status](https://travis-ci.org/maiha/selenium-chrome.cr.svg?branch=master)](https://travis-ci.org/maiha/selenium-chrome.cr)

A handy and thin wrapper for `selenium-webdriver-crystal`.

- crystal: 0.24.2

## Component

- Selenium Server (**You must prepare**)
  - [ ] server: docker [selenium/standalone-chrome-debug:3.11.0](https://hub.docker.com/r/selenium/standalone-chrome-debug/)
  - [x] driver: chrome (bundled in above image)
- Selenium Client
  - [x] driver: https://github.com/ysbaddaden/selenium-webdriver-crystal
  - [x] helper: THIS REPOSITORY (provides handy dsl like `find`)
  - [ ] client: Please see "USAGE" and **write as you like**.

## Prepare Server
The simplest way is
```shell
docker run -d -p 4444:4444 selenium/standalone-chrome:3.11.0
```

## Usage

```crystal
require "selenium-chrome"

session = Selenium::Chrome.new
session.open "https://github.com/maiha/selenium-chrome.cr"

session.find(css: "article>h1").text # => "selenium-chrome.cr"
session.find(css: "xxx")             # raises Selenium::WebElement::NotFound
session.find?(css: "xxx")            # => nil

session.close
```

async downloader

```crystal
bytes = session.download(timeout: 60.seconds) {
  session.find(css: "a>img[name='csv']").click
}
```

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  selenium-chrome:
    github: maiha/selenium-chrome.cr
    version: 0.1.3
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
