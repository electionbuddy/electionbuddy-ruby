# frozen_string_literal: true

module ElectionBuddy
  class Validation
    class LineError
      attr_reader :voter_information_line_id, :errors

      def initialize(line_error)
        @voter_information_line_id = line_error["voter_information_line_id"]
        @errors = line_error["errors"]
      end

      def error_messages
        @errors.map do |(category, messages)|
          "#{category}: #{messages.join(", ")}"
        end
      end
    end
  end
end
