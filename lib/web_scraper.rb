# frozen_string_literal: true

require 'web_scraper/scraper'
require 'web_scraper/version'
require 'web_scraper/page/step/base'
require 'web_scraper/page/fetcher/base'
require 'web_scraper/page/fetcher/null'
require 'web_scraper/chrome_browser'
require 'web_scraper/firefox_browser'

module WebScraper
  class Error < StandardError; end
  # Your code goes here...
end
