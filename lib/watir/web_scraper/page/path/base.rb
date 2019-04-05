# frozen_string_literal: true

module Watir
  module WebScraper
    module Page
      module Path
        class Base
          def initialize(browser, params)
            @browser = browser
            @params = params
          end

          def call
            perform_steps
          end

          alias start call

          private

          attr_reader :browser, :params

          def perform_steps
            self.class::STEPS.each do |step|
              step.new(browser, params).start
            end
          end
        end
      end
    end
  end
end
