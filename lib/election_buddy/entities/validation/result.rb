# frozen_string_literal: true

module ElectionBuddy
  class Validation
    class UnavailableTotalErrorsCount < ElectionBuddy::Error; end
    class UnavailableValidStatus < ElectionBuddy::Error; end

    Success = ->(data) { { success?: true, data: data } }
    Failure = ->(error) { { success?: false, error: error } }
    private_constant :Success, :Failure

    class Result
      def initialize(response)
        @result = process_response(response)
      end

      def list_errors
        return [] unless success?

        @list_errors ||= ListErrors.new(@result[:data].dig("results", "voter_list_validations"))
      end

      def line_errors
        return [] unless success?

        @line_errors ||= LineErrors.new(@result[:data].dig("results", "voter_lines_validation"))
      end

      def total_errors_count
        raise UnavailableTotalErrorsCount, failure_message if failure?

        list_errors.total + line_errors.total
      end

      def valid?
        raise UnavailableValidStatus, failure_message if failure?

        total_errors_count.zero?
      end

      def failure_error
        return if success?

        ::ElectionBuddy::ErrorFormatter.format(@result[:error])
      end

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
