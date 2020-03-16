# frozen_string_literal: true

module Watir
  module WebScraper
    module Browser
      class Chrome < Watir::Browser
        def initialize(options = {})
          super(:chrome, options)
        end
      end
    end
  end
end
