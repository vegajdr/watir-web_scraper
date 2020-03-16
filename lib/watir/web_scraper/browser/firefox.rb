# frozen_string_literal: true

module Watir
  module WebScraper
    module Browser
      class Firefox < Watir::Browser
        def initialize(options = {})
          super(:firefox, options)
        end
      end
    end
  end
end
