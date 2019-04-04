# frozen_string_literal: true

require 'watir'

module WebScraper
  class FirefoxBrowser < Watir::Browser
    def initialize(browser = :firefox)
      super(browser)
    end
  end
end
