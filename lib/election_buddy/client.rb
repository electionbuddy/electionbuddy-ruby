# frozen_string_literal: true

module ElectionBuddy
  class Client
    BASE_URL = "https://secure.electionbuddy.com/api/v2"

    def initialize(api_key, adapter: Faraday.default_adapter, stubs: nil)
      @api_key = api_key
      @adapter = adapter
      @stubs = stubs
    end

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
