# frozen_string_literal: true

module ElectionBuddy
  # HTTP client for the ElectionBuddy API
  #
  # @example
  #   client = Client.new(api_key: "your-api-key")
  #   client.voter_list.validate(123)
  #
  class Client
    BASE_URL = "https://secure.electionbuddy.com/api/v2"

    # @param api_key [String, nil] The API key for authentication (optional if configured globally)
    # @param adapter [Object, nil] The HTTP client adapter to use (optional, defaults to Faraday's default adapter)
    # @param stubs [Object, nil] Test stubs for the adapter (optional)
    def initialize(api_key: nil, adapter: Faraday.default_adapter, stubs: nil)
      @api_key = api_key || ElectionBuddy.configuration.api_key
      @adapter = adapter
      @stubs = stubs
    end

    # Returns the voter list resource for handling voter-related operations
    #
    # @return [VoterListResource] The voter list resource
    def voter_list
      VoterListResource.new(connection)
    end

    private

    def connection
      @connection ||= Faraday.new(BASE_URL) do |conn|
        conn.headers["authorization"] = @api_key
        conn.request :json
        conn.response :json, content_type: /\bjson$/
        conn.adapter @adapter, @stubs
      end
    end
  end
end
