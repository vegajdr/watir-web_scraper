# frozen_string_literal: true

require 'forwardable'

module Watir
  module WebScraper
    class Fetcher
      class Collection
        extend Forwardable
        def_delegators :fetchers, :<<

        def initialize(fetchers = [])
          @fetchers = fetchers
        end

        def fetched_data
          fetchers
            .map(&:fetched_data)
            .reduce({}, :merge)
        end

        private

        attr_reader :fetchers
      end
    end
  end
end
