# frozen_string_literal: true

module ElectionBuddy
  class Validation
    # Represents a collection of line-by-line validation errors
    #
    # @example
    #   line_errors = LineErrors.new(response)
    #   line_errors.total #=> 5
    #   line_errors.total_pages #=> 1
    #   line_errors.empty? #=> false
    #
    class LineErrors
      include Enumerable

      # @return [Integer] Total number of validation errors
      attr_reader :total

      # @return [Integer] Current page number
      attr_reader :page

      # @return [Integer] Number of items per page
      attr_reader :per_page

      # @param response [Hash] API response containing validation errors
      def initialize(response)
        @line_errors = response["voter_line_errors"]
        @total = response["meta"]["total"]
        @page = response["meta"]["page"]
        @per_page = response["meta"]["per_page"]
      end

      # Calculates the total number of pages
      #
      # @return [Integer] Total number of pages
      def total_pages
        (total.to_f / per_page).ceil
      end

      # Iterates through each line error
      #
      # @return [Enumerator] Collection of line errors
      def each(&block)
        collection.each(&block)
      end

      # Checks if there are any line errors
      #
      # @return [Boolean] true if no errors exist, false otherwise
      def empty?
        collection.empty?
      end

      private

      def collection
        @collection ||= @line_errors.map { |line_error| LineError.new(line_error) }
      end
    end
  end
end
