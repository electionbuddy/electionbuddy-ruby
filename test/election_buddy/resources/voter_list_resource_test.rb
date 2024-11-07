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
  end
end
