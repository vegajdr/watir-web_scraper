# frozen_string_literal: true

module WebScraper
  module Page
    module Step
      class Base
        def initialize(browser, params = {})
          @browser = browser
          @params = params
        end

        def call
          instructions
        end

        alias start call

        private

        def instructions
          raise NotImplementedError, 'This is an abstract base method. Implement in your subclass'
        end

        attr_reader :browser, :params
      end
    end
  end
end
