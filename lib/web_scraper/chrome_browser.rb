# frozen_string_literal: true

require 'watir'

module WebScraper
  class ChromeBrowser < Watir::Browser
    def initialize(browser = :chrome)
      super(browser)
    end
  end
end
