# frozen_string_literal: true

require 'watir'
require 'watir/web_scraper/scraper'
require 'watir/web_scraper/version'
require 'watir/web_scraper/step'
require 'watir/web_scraper/path'
require 'watir/web_scraper/fetcher'
require 'watir/web_scraper/browser/chrome'
require 'watir/web_scraper/browser/firefox'
require 'watir/web_scraper/retryable'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/time/zones'
require 'active_support/core_ext/array/wrap'
require 'net/http'

module Watir
  module WebScraper
    class Error < StandardError; end
  end
end
