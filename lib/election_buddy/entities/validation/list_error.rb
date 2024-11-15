# frozen_string_literal: true

require "debug"

module ElectionBuddy
  class Validation
    class ListError
      attr_reader :error, :category, :messages

      def initialize(error)
        @error = error
        @category, @messages = error.first
      end

      def error_message
        "#{category}: #{messages.join(", ")}"
      end
    end
  end
end
