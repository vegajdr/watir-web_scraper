# frozen_string_literal: true

module Watir
  module WebScraper
    # This object is responsible of executing the routine of a collection of actions that
    # represent the client navigating through the browser
    class Scraper
      Error = Class.new(StandardError)

      DEFAULT_MAX_ATTEMPTS = 1

      attr_reader :errors, :attempts, :actions

      def initialize(args)
        @browser_class = args[:browser] || Browser::Firefox
        @params = args[:params] || {}
        @max_attempts = args[:max_attempts] || DEFAULT_MAX_ATTEMPTS
        @actions = Array.wrap(args[:actions])
        @fetcher = Fetcher::Null.new
        @errors = []
        @attempts = 0
      end

      def perform
        perform!
      rescue *default_exceptions
        false
      end

      def perform!
        Retryable.retry_on_error(retry_options) { scrape_routine }
        true
      rescue *default_exceptions => exception
        add_errors.call(exception)
        raise exception
      ensure
        close_browser.call
      end

      def fetched_data
        fetcher.fetched_data
      end

      private

      attr_reader :browser,
                  :browser_class,
                  :fetcher,
                  :max_attempts,
                  :params

      def retry_options
        {
          tries: max_attempts,
          on: retryable_exceptions,
          exception_cb: add_errors,
          ensure_cb: close_browser
        }
      end

      def scrape_routine
        @attempts += 1
        ensure_browser

        actions.each do |action|
          instance = action.new(browser, params).start
          @fetcher = instance if instance.respond_to?(:fetch)
        end

        true
      end

      def default_exceptions
        retryable_exceptions + non_retryable_exceptions
      end

      def retryable_exceptions
        [Watir::Exception::Error,
         Watir::Wait::TimeoutError,
         Selenium::WebDriver::Error::WebDriverError,
         ::Net::ReadTimeout]
      end

      def non_retryable_exceptions
        [Error]
      end

      def add_errors
        proc do |error|
          errors << { message: error.message, time: ::Time.now }
        end
      end

      def close_browser
        proc { browser&.close }
      end

      def ensure_browser
        @browser = browser_class.new unless browser&.exists?
      end
    end
  end
end
