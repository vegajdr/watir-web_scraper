# frozen_string_literal: true

module Watir
  module WebScraper
    # Provides functionality to retry a block of code a given an amount of times based
    # on allowed retryable exceptions
    module Retryable
      def retry_on_error(options = {})
        options = default_options.merge(options)
        tries = options[:tries]
        begin
          yield
        rescue *Array.wrap(options[:on]) => exception
          options[:exception_cb].call(exception)
          raise exception if (tries -= 1).zero?

          retry
        ensure
          options[:ensure_cb].call
        end
      end

      module_function :retry_on_error

      def default_options
        {
          ensure_cb: proc {},
          exception_cb: proc {},
          on: StandardError,
          tries: 2
        }
      end

      module_function :default_options
      private_class_method :default_options
    end
  end
end
