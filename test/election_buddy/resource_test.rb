# frozen_string_literal: true

require "test_helper"

module ElectionBuddy
  class ResourceTest < Minitest::Test
    def setup
      @stubs = Faraday::Adapter::Test::Stubs.new
      connection = Faraday.new do |faraday|
        faraday.response :json, content_type: /\bjson$/
        faraday.adapter :test, @stubs
      end
      @resource = Resource.new(connection)
    end

    def test_handle_success_response
      @stubs.get("/test_endpoint") { [200, { "Content-Type" => "application/json" }, '{"data": "test"}'] }
      assert_equal({ "data" => "test" }, @resource.get_request("/test_endpoint"))
    end

    def test_handle_success_post_response
      @stubs.post("/test_endpoint") { [201, { "Content-Type" => "application/json" }, '{"data": "created"}'] }
      assert_equal({ "data" => "created" }, @resource.post_request("/test_endpoint", { param: "value" }))
    end

    def test_handle_bad_request_response
      @stubs.get("/test_endpoint") do
        [400, { "Content-Type" => "application/json" }, '{"id": "must be provided"}']
      end
      error = assert_raises(Error) { @resource.get_request("/test_endpoint") }
      assert_equal("Error 400: Malformed request - Id: must be provided.", error.message)
    end

    def test_handle_unauthorized_response
      @stubs.get("/test_endpoint") { [401, { "Content-Type" => "application/json" }, "{}"] }
      error = assert_raises(Error) { @resource.get_request("/test_endpoint") }
      assert_equal("Error 401: Invalid authentication credentials.", error.message)
    end

    def test_handle_forbidden_response
      @stubs.get("/test_endpoint") { [403, { "Content-Type" => "application/json" }, "{}"] }
      error = assert_raises(Error) { @resource.get_request("/test_endpoint") }
      assert_equal("Error 403: Unauthorized.", error.message)
    end

    def test_handle_not_found_response
      @stubs.get("/test_endpoint") { [404, { "Content-Type" => "application/json" }, "{}"] }
      error = assert_raises(Error) { @resource.get_request("/test_endpoint") }
      assert_equal("Error 404: Resource not found.", error.message)
    end

    def test_handle_too_many_requests_response
      @stubs.get("/test_endpoint") do
        [429, { "Content-Type" => "application/json" }, "{}"]
      end
      error = assert_raises(Error) { @resource.get_request("/test_endpoint") }
      assert_equal("Error 429: Your request exceeded the API rate limit.", error.message)
    end

    def test_handle_internal_server_error_response
      @stubs.get("/test_endpoint") do
        [500, { "Content-Type" => "application/json" }, "{}"]
      end
      error = assert_raises(Error) { @resource.get_request("/test_endpoint") }
      assert_equal(
        "Error 500: We were unable to perform the request due to server-side problems.", error.message
      )
    end

    def test_handle_unknown_error_response
      @stubs.get("/test_endpoint") { [504, { "Content-Type" => "application/json" }, '{"message": "unknown"}'] }
      error = assert_raises(Error) { @resource.get_request("/test_endpoint") }
      assert_equal("Error 504: Unexpected status code. - Message: unknown.", error.message)
    end
  end
end
