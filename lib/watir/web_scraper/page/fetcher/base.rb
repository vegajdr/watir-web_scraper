# frozen_string_literal: true

module Watir
  module WebScraper
    module Page
      module Fetcher
        class Base
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
        end
      end
    end
  end
end
