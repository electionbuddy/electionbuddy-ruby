# frozen_string_literal: true

require "test_helper"

module ElectionBuddy
  class Validation
    class ListErrorsTest < Minitest::Test
      def setup
        validation_with_errors = {
          "voter_list_errors" => {
            "voter_list_overflow" => [
              "Test elections cannot have more than 5 voters. You have a list of 10 voter(s) and 0 manual key(s) reserved."
            ]
          },
          "meta" => { "total" => 1 }
        }
        validation_without_errors = {
          "voter_list_errors" => {},
          "meta" => { "total" => 0 }
        }

        @list_errors = ListErrors.new(validation_with_errors)
        @empty_list_errors = ListErrors.new(validation_without_errors)
      end

      def test_total_with_errors
        assert_equal 1, @list_errors.total
      end

      def test_total_without_errors
        assert_equal 0, @empty_list_errors.total
      end

      def test_empty_list
        assert @empty_list_errors.empty?
      end

      def test_each_yields_list_error_instances
        @list_errors.each do |error|
          assert_instance_of ListError, error
          assert_equal "voter_list_overflow", error.category
          assert_includes error.messages,
                          "Test elections cannot have more than 5 voters. You have a list of 10 voter(s) and 0 manual key(s) reserved."
        end
      end
    end
  end
end
