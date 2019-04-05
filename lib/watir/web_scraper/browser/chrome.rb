# frozen_string_literal: true

module Watir
  module WebScraper
    module Browser
      class Chrome < Watir::Browser
        def initialize(browser = :chrome)
          super(browser)
        end
      end
    end
  end
end
