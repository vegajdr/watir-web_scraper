# frozen_string_literal: true

require 'watir/web_scraper/scraper'
require 'watir/web_scraper/version'
require 'watir/web_scraper/page/step/base'
require 'watir/web_scraper/page/fetcher/base'
require 'watir/web_scraper/page/fetcher/null'
require 'watir/web_scraper/chrome_browser'
require 'watir/web_scraper/firefox_browser'

module Watir
  module WebScraper
    class Error < StandardError; end
    # Your code goes here...
  end
end
