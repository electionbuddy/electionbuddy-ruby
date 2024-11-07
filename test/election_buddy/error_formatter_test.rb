# frozen_string_literal: true

require "test_helper"
require "election_buddy/error_formatter"

module ElectionBuddy
  class ErrorFormatterTest < Minitest::Test
    def test_format_with_nil
      assert_nil ErrorFormatter.format(nil)
    end

    def test_format_with_empty_hash
      assert_nil ErrorFormatter.format({})
    end

    def test_format_with_single_error
      error_hash = { "some_error" => "An error occurred" }
      expected_output = "Some Error: An error occurred"

      assert_equal expected_output, ErrorFormatter.format(error_hash)
    end

    def test_format_with_multiple_errors
      error_hash = { "first_error" => "First error occurred", "second_error" => "Second error occurred" }
      expected_output = "First Error: First error occurred, Second Error: Second error occurred"

      assert_equal expected_output, ErrorFormatter.format(error_hash)
    end

    def test_format_with_array_value
      error_hash = { "some_error" => ["First error", "Second error"] }
      expected_output = "Some Error: First error, Second error"

      assert_equal expected_output, ErrorFormatter.format(error_hash)
    end
  end
end
