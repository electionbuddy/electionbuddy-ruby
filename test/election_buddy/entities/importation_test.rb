# frozen_string_literal: true

require "test_helper"

module ElectionBuddy
  class ImportationTest < Minitest::Test
    def test_identifier
      response = { "importation_identifier" => "12345" }
      importation = Importation.new(response)

      assert_equal "12345", importation.identifier
    end

    def test_identifier_not_available
      response = {}
      importation = Importation.new(response)

      assert_equal "Not Available", importation.identifier
    end

    def test_done_when_no_error
      response = { "error" => nil }
      importation = Importation.new(response)

      assert importation.done?
    end

    def test_not_done_when_error_present
      response = { "error" => { "some_error" => "error message" } }
      importation = Importation.new(response)

      refute importation.done?
    end

    def test_error_formatting
      response = { "error" => { "some_error" => ["error message 1", "error message 2"] } }
      importation = Importation.new(response)
      expected_error_message = "Some Error: error message 1, error message 2"

      assert_equal expected_error_message, importation.error
    end

    def test_no_error_when_done
      response = { "error" => nil }
      importation = Importation.new(response)

      assert_nil importation.error
    end
  end
end
