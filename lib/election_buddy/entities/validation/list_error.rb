# frozen_string_literal: true

module ElectionBuddy
  class Validation
    # Represents a single voter list validation error
    #
    # @example
    #   error = ListError.new({ "email" => ["is invalid", "is required"] })
    #   error.category #=> "email"
    #   error.messages #=> ["is invalid", "is required"]
    #   error.error_message #=> "email: is invalid, is required"
    #
    class ListError
      # @return [Hash] The raw error data
      attr_reader :error

      # @return [String] The category of the error
      attr_reader :category

      # @return [Array<String>] The error messages
      attr_reader :messages

      # @param error [Hash] The error hash containing category and messages
      def initialize(error)
        @error = error
        @category, @messages = error.first
      end

      # Returns a formatted error message
      #
      # @return [String] The formatted error message
      def error_message
        "#{category}: #{messages.join(", ")}"
      end
    end
  end
end
