# frozen_string_literal: true

module ElectionBuddy
  class Validation
    # Represents a single line validation error
    #
    # @example
    #   line_error = LineError.new({ "voter_information_line_id" => 123, "errors" => { "email" => ["is invalid"] } })
    #   line_error.voter_information_line_id #=> 123
    #   line_error.error_messages #=> ["email: is invalid"]
    #
    class LineError
      # @return [Integer] The ID of the voter information line
      attr_reader :voter_information_line_id

      # @return [Hash] The errors hash containing categories and messages
      attr_reader :errors

      # @param line_error [Hash] The error hash containing line ID and errors
      def initialize(line_error)
        @voter_information_line_id = line_error["voter_information_line_id"]
        @errors = line_error["errors"]
      end

      # Returns formatted error messages for each category
      #
      # @return [Array<String>] Array of formatted error messages
      def error_messages
        @errors.map do |(category, messages)|
          "#{category}: #{messages.join(", ")}"
        end
      end
    end
  end
end
