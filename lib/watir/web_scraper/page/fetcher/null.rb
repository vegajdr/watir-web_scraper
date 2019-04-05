# frozen_string_literal: true

module Watir
  module WebScraper
    module Page
      module Fetcher
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
end
