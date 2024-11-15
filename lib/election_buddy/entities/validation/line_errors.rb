# frozen_string_literal: true

module ElectionBuddy
  class Validation
    class LineErrors
      include Enumerable

      attr_reader :total, :page, :per_page

      def initialize(response)
        @line_errors = response["voter_line_errors"]
        @total = response["meta"]["total"]
        @page = response["meta"]["page"]
        @per_page = response["meta"]["per_page"]
      end

      def total_pages
        (total.to_f / per_page).ceil
      end

      def each(&block)
        collection.each(&block)
      end

      def empty?
        collection.empty?
      end

      def collection
        @collection ||= @line_errors.map { |line_error| LineError.new(line_error) }
      end
    end
  end
end
