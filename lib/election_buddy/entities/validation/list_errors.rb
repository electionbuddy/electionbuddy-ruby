# frozen_string_literal: true

module ElectionBuddy
  class Validation
    class ListErrors
      include Enumerable

      attr_reader :total

      def initialize(response)
        @list_errors = response["voter_list_errors"]
        @total = response["meta"]["total"]
      end

      def each(&block)
        collection.each(&block)
      end

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
