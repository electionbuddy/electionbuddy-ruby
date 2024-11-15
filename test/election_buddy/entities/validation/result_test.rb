# frozen_string_literal: true

require "test_helper"

module ElectionBuddy
  class Validation
    class ResultTest < Minitest::Test
      def setup
        @valid_response = valid_response
        @list_error_response = list_error_response
        @line_error_response = line_error_response
        @error_response = error_response
      end

      def test_successful_result_state
        result = Result.new(@valid_response)
        assert_nil result.failure_error
        assert_nil result.failure_message
      end

      def test_failed_result_state
        result = Result.new(@error_response)
        assert_equal "Validation: not found", result.failure_error
        assert_equal "API call has failed - Error: Validation: not found", result.failure_message
      end

      def test_valid_result
        result = Result.new(@valid_response)
        assert result.valid?
        assert_equal 0, result.total_errors_count
      end

      def test_list_validation_errors
        result = Result.new(@list_error_response)
        refute result.valid?
        assert_equal 1, result.total_errors_count
      end

      def test_line_validation_errors
        result = Result.new(@line_error_response)
        refute result.valid?
        assert_equal 2, result.total_errors_count
      end

      def test_list_errors_returns_proper_instance
        result = Result.new(@list_error_response)
        list_errors = result.list_errors
        assert_instance_of ListErrors, list_errors
      end

      def test_line_errors_returns_proper_instance
        result = Result.new(@line_error_response)
        line_errors = result.line_errors
        assert_instance_of LineErrors, line_errors
      end

      def test_list_errors_returns_empty_array_on_failure
        result = Result.new(@error_response)
        assert_empty result.list_errors
      end

      def test_line_errors_returns_empty_array_on_failure
        result = Result.new(@error_response)
        assert_empty result.line_errors
      end

      def test_total_errors_count_raises_error_on_failure
        result = Result.new(@error_response)
        assert_raises(UnavailableTotalErrorsCount) { result.total_errors_count }
      end

      def test_valid_status_raises_error_on_failure
        result = Result.new(@error_response)
        assert_raises(UnavailableValidStatus) { result.valid? }
      end

      private

      def valid_response
        {
          "results" => {
            "vote_id" => 58_812,
            "validation_id" => 929,
            "identifier" => "90dd086d-d4a3-4f02-9de4-221880355052",
            "voter_list_validations" => valid_list_validation,
            "voter_lines_validation" => valid_line_validation
          }
        }
      end

      def list_error_response
        {
          "results" => {
            "vote_id" => 58_777,
            "validation_id" => 935,
            "identifier" => "ba1716d5-a5f4-4b8f-ad0b-5f6e868caf51",
            "voter_list_validations" => list_validation_with_errors,
            "voter_lines_validation" => valid_line_validation
          }
        }
      end

      def line_error_response
        {
          "results" => {
            "vote_id" => 58_787,
            "validation_id" => 937,
            "identifier" => "dfe4c244-5b92-4158-85a8-696025480d30",
            "voter_list_validations" => valid_list_validation,
            "voter_lines_validation" => line_validation_with_errors
          }
        }
      end

      def error_response
        {
          "error" => {
            "validation" => "not found"
          }
        }
      end

      def valid_list_validation
        {
          "voter_list_errors" => {},
          "meta" => { "total" => 0 }
        }
      end

      def valid_line_validation
        {
          "voter_line_errors" => [],
          "meta" => { "total" => 0, "page" => 1, "per_page" => 10 }
        }
      end

      def list_validation_with_errors
        {
          "voter_list_errors" => {
            "voter_list_overflow" => [
              "Test elections cannot have more than 5 voters. You have a list of 10 voter(s) and 0 manual key(s) reserved."
            ]
          },
          "meta" => { "total" => 1 }
        }
      end

      def line_validation_with_errors
        {
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
      end
    end
  end
end
