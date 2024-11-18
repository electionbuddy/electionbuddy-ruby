# frozen_string_literal: true

module ElectionBuddy
  class Validation
    class UnavailableTotalErrorsCount < ElectionBuddy::Error; end
    class UnavailableValidStatus < ElectionBuddy::Error; end

    Success = ->(data) { { success?: true, data: data } }
    Failure = ->(error) { { success?: false, error: error } }
    private_constant :Success, :Failure

    # Represents the result of a validation operation
    #
    # @example Check if validation passed
    #   result = Result.new(response)
    #   result.valid? #=> true
    #   result.total_errors_count #=> 0
    #
    # @example Handle validation errors
    #   result = Result.new(response)
    #   result.valid? #=> false
    #   result.total_errors_count #=> 3
    #   result.list_errors #=> #<ListErrors @total=1>
    #   result.line_errors #=> #<LineErrors @total=2>
    #
    # @example Handle API failures
    #   result = Result.new(response)
    #   result.valid? #=> raises UnavailableValidStatus
    #   result.total_errors_count #=> raises UnavailableTotalErrorsCount
    #   result.failure_message #=> "API call has failed - Error: Validation: not found"
    class Result
      # Initializes a new validation result
      # @param response [Hash] The raw response from the validation API
      def initialize(response)
        @result = process_response(response)
      end

      # Returns the list of validation errors related to the voter list
      # @return [ListErrors, Array] List validation errors or empty array if validation failed
      def list_errors
        return [] unless success?

        @list_errors ||= ListErrors.new(@result[:data].dig("results", "voter_list_validations"))
      end

      # Returns the line-by-line validation errors
      # @return [LineErrors, Array] Line validation errors or empty array if validation failed
      def line_errors
        return [] unless success?

        @line_errors ||= LineErrors.new(@result[:data].dig("results", "voter_lines_validation"))
      end

      # Returns the total count of all validation errors
      # @return [Integer] Total number of validation errors
      # @raise [UnavailableTotalErrorsCount] if the API call failed
      def total_errors_count
        raise UnavailableTotalErrorsCount, failure_message if failure?

        list_errors.total + line_errors.total
      end

      # Indicates if the validation passed without errors
      # @return [Boolean] true if validation passed, false otherwise
      # @raise [UnavailableValidStatus] if the API call failed
      def valid?
        raise UnavailableValidStatus, failure_message if failure?

        total_errors_count.zero?
      end

      # Returns the error message if validation failed
      # @return [String, nil] The formatted error message or nil if successful
      def failure_error
        return if success?

        ::ElectionBuddy::ErrorFormatter.format(@result[:error])
      end

      # Returns a user-friendly failure message
      # @return [String, nil] The failure message or nil if successful
      def failure_message
        return if success?

        "API call has failed - Error: #{failure_error}"
      end

      private

      def success?
        @result[:success?]
      end

      def failure?
        !success?
      end

      def process_response(response)
        if response["error"]
          Failure.call(response["error"])
        else
          Success.call(response)
        end
      end
    end
  end
end
