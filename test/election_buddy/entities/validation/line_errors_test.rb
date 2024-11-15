# frozen_string_literal: true

require "test_helper"

module ElectionBuddy
  class Validation
    class LineErrorsTest < Minitest::Test
      def setup
        @line_validation_with_errors = {
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
        @line_errors = LineErrors.new(@line_validation_with_errors)
      end

      def test_initialization
        assert_equal 2, @line_errors.total
        assert_equal 1, @line_errors.page
        assert_equal 10, @line_errors.per_page
      end

      def test_total_pages_calculation
        assert_equal 1, @line_errors.total_pages

        validation_with_more_errors = @line_validation_with_errors.dup
        validation_with_more_errors["meta"]["total"] = 15
        line_errors = LineErrors.new(validation_with_more_errors)
        assert_equal 2, line_errors.total_pages
      end

      def test_enumerable_implementation
        assert_kind_of Enumerable, @line_errors
        assert_equal 2, @line_errors.count
      end

      def test_collection_contains_line_error_instances
        @line_errors.each do |error|
          assert_instance_of LineError, error
        end
      end

      def test_collection_maps_data_correctly
        first_error = @line_errors.first
        assert_equal 17_346_137, first_error.voter_information_line_id
        assert_equal({ "email" => ["Email has the wrong format"] }, first_error.errors)
      end
    end
  end
end
