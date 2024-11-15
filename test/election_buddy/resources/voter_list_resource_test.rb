# frozen_string_literal: true

require "test_helper"

module ElectionBuddy
  class VoterListResourceTest < Minitest::Test
    def setup
      @stubs = Faraday::Adapter::Test::Stubs.new
      connection = Faraday.new do |faraday|
        faraday.response :json, content_type: /\bjson$/
        faraday.adapter :test, @stubs
      end
      @resource = VoterListResource.new(connection)
    end

    def test_validate_success
      @stubs.post("/api/v2/votes/voters/validations") do
        [201, { "Content-Type" => "application/json" },
         '{"validation_identifier": "ae0a1724-9791-4bb2-8331-6d4e55a9b7c8"}']
      end

      validation = @resource.validate(58_812)

      assert_equal "ae0a1724-9791-4bb2-8331-6d4e55a9b7c8", validation.identifier
      assert validation.done?
      assert_nil validation.error
    end

    def test_validate_failure
      @stubs.post("/api/v2/votes/voters/validations") do
        [422, { "Content-Type" => "application/json" }, '{"error": {"vote": "not found"}}']
      end

      validation = @resource.validate(58_812)

      refute validation.done?
      assert_equal "Vote: not found", validation.error
    end

    def test_get_validation_result_success
      @stubs.get("/api/v2/votes/voters/validations?identifier=test-id&page=1&per_page=10") do
        [200, { "Content-Type" => "application/json" },
         { results: {
           vote_id: 58_812,
           validation_id: 929,
           identifier: "test-id",
           voter_list_validations: {
             voter_list_errors: {},
             meta: { total: 0 }
           },
           voter_lines_validation: {
             voter_line_errors: [],
             meta: { total: 0, page: 1, per_page: 10 }
           }
         } }.to_json]
      end

      result = @resource.get_validation_result("test-id")

      assert result.valid?
      assert_equal 0, result.total_errors_count
      assert_empty result.list_errors
      assert_empty result.line_errors
    end

    def test_get_validation_result_with_errors
      @stubs.get("/api/v2/votes/voters/validations?identifier=test-id&page=1&per_page=10") do
        [200, { "Content-Type" => "application/json" },
         { results: {
           vote_id: 58_777,
           validation_id: 935,
           identifier: "test-id",
           voter_list_validations: {
             voter_list_errors: {
               voter_list_overflow: ["Test elections cannot have more than 5 voters"]
             },
             meta: { total: 1 }
           },
           voter_lines_validation: {
             voter_line_errors: [],
             meta: { total: 0, page: 1, per_page: 10 }
           }
         } }.to_json]
      end

      result = @resource.get_validation_result("test-id")

      refute result.valid?
      assert_equal 1, result.total_errors_count
      refute_empty result.list_errors
    end

    def test_get_validation_result_failure
      @stubs.get("/api/v2/votes/voters/validations?identifier=invalid-id&page=1&per_page=10") do
        [422, { "Content-Type" => "application/json" },
         { error: { validation: "not found" } }.to_json]
      end

      result = @resource.get_validation_result("invalid-id")

      assert_equal "Validation: not found", result.failure_error
      assert_equal "API call has failed - Error: Validation: not found", result.failure_message
      assert_raises(::ElectionBuddy::Validation::UnavailableTotalErrorsCount) { result.total_errors_count }
      assert_raises(::ElectionBuddy::Validation::UnavailableValidStatus) { result.valid? }
    end
  end
end
