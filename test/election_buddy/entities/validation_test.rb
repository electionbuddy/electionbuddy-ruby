# frozen_string_literal: true

require "test_helper"

module ElectionBuddy
  class ValidationTest < Minitest::Test
    def test_identifier
      response = { "validation_identifier" => "12345" }
      validation = Validation.new(response)
      assert_equal "12345", validation.identifier
    end

    def test_identifier_not_available
      response = {}
      validation = Validation.new(response)
      assert_equal "Not available", validation.identifier
    end

    def test_done_when_no_error
      response = { "error" => nil }
      validation = Validation.new(response)
      assert validation.done?
    end

    def test_not_done_when_error_present
      response = { "error" => { "some_error" => "error message" } }
      validation = Validation.new(response)
      refute validation.done?
    end

    def test_error_formatting
      response = { "error" => { "some_error" => ["error message 1", "error message 2"] } }
      validation = Validation.new(response)
      expected_error_message = "Some Error: error message 1, error message 2"
      assert_equal expected_error_message, validation.error
    end

    def test_no_error_when_done
      response = { "error" => nil }
      validation = Validation.new(response)
      assert_nil validation.error
    end
  end
end
