# frozen_string_literal: true

module Watir
  module WebScraper
    module Browser
      class Firefox < Watir::Browser
        def initialize(browser = :firefox)
          super(browser)
        end
      end
    end
  end
end
