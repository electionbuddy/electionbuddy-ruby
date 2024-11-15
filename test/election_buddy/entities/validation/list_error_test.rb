# frozen_string_literal: true

require "test_helper"

module ElectionBuddy
  class Validation
    class ListErrorTest < Minitest::Test
      def setup
        @error_hash = {
          "voter_list_overflow" => [
            "Test elections cannot have more than 5 voters. You have a list of 10 voter(s) and 0 manual key(s) reserved."
          ]
        }
        @list_error = ListError.new(@error_hash)
      end

      def test_initialization
        assert_equal "voter_list_overflow", @list_error.category
        assert_equal ["Test elections cannot have more than 5 voters. You have a list of 10 voter(s) and 0 manual key(s) reserved."],
                     @list_error.messages
        assert_equal @error_hash, @list_error.error
      end

      def test_error_message
        expected = "voter_list_overflow: Test elections cannot have more than 5 voters. You have a list of 10 voter(s) and 0 manual key(s) reserved."
        assert_equal expected, @list_error.error_message
      end
    end
  end
end
