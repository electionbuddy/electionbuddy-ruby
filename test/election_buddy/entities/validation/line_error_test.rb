# frozen_string_literal: true

require "test_helper"

module ElectionBuddy
  class Validation
    class LineErrorTest < Minitest::Test
      def setup
        line_validation_with_errors = {
          "voter_line_errors" => [
            {
              "voter_information_line_id" => 17_346_137,
              "errors" => { "email" => ["Email has the wrong format"] }
            },
            {
              "voter_information_line_id" => 17_346_135,
              "errors" => { "email" => ["Email has the wrong format"] }
            }
          ],
          "meta" => { "total" => 2, "page" => 1, "per_page" => 10 }
        }
        @line_error_data = line_validation_with_errors["voter_line_errors"].first
        @line_error = LineError.new(@line_error_data)
      end

      def test_initialization
        assert_equal 17_346_137, @line_error.voter_information_line_id
        assert_equal({ "email" => ["Email has the wrong format"] }, @line_error.errors)
      end

      def test_error_messages
        expected_messages = ["email: Email has the wrong format"]
        assert_equal expected_messages, @line_error.error_messages
      end
    end
  end
end
