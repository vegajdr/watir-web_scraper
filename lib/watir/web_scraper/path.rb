# frozen_string_literal: true

module Watir
  module WebScraper
    # This class allows the organization of steps to be performed in sequence
    class Path
      def initialize(browser, params, fetched_data)
        @browser = browser
        @params = params
        @fetched_data = fetched_data
      end

      def call
        perform_steps
      end

      def fetcher?
        false
      end

      alias start call

      private

      attr_reader :browser, :params, :fetched_data

      def perform_steps
        self.class::STEPS.each do |step|
          step.new(browser, params, fetched_data).start
        end
      end
    end
  end
end
