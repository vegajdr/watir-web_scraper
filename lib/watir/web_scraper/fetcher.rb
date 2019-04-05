# frozen_string_literal: true

module Watir
  module WebScraper
    # This class is responsible for providing a `fetched_data` method as an
    # interface to grab data from a visited page
    class Fetcher
      attr_reader :fetched_data

      def initialize(browser, options = {})
        @browser = browser
        @options = options
        @fetched_data = {}
      end

      def call
        fetch
        self
      end

      alias start call

      private

      def fetch
        raise NotImplementedError
      end

      attr_reader :browser

      class Null
        def fetched_data
          {}
        end

        def fetch; end

        alias start fetch
      end
    end
  end
end
