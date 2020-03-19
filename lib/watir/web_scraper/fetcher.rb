# frozen_string_literal: true

module Watir
  module WebScraper
    # This class is responsible for providing a `fetched_data` method as an
    # interface to grab data from a visited page
    class Fetcher
      attr_reader :fetched_data

      def initialize(browser, params, fetched_data)
        @browser = browser
        @params = params
        @fetched_data = fetched_data
      end

      def call
        fetch
        self
      end

      alias start call

      def fetch
        raise NotImplementedError, 'implement a #fetch method your subclass which returns a data hash'
      end

      def fetcher?
        true
      end

      private

      attr_reader :browser, :params
    end
  end
end
