# frozen_string_literal: true

module ElectionBuddy
  class Validation
    # Represents a collection of voter list validation errors
    #
    # @example
    #   list_errors = ListErrors.new(response)
    #   list_errors.total #=> 2
    #   list_errors.empty? #=> false
    #
    class ListErrors
      include Enumerable

      # @return [Integer] Total number of validation errors
      attr_reader :total

      # @param response [Hash] API response containing validation errors
      def initialize(response)
        @list_errors = response["voter_list_errors"]
        @total = response["meta"]["total"]
      end

      # Iterates through each list error
      #
      # @return [Enumerator] Collection of list errors
      def each(&block)
        collection.each(&block)
      end

      # Checks if there are any list errors
      #
      # @return [Boolean] true if no errors exist, false otherwise
      def empty?
        collection.empty?
      end

      private

      def collection
        @collection ||= @list_errors
                        .map { |category, messages| { category => messages } }
                        .map { |list_error| ListError.new(list_error) }
      end
    end
  end
end
