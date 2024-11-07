# frozen_string_literal: true

require "test_helper"

module ElectionBuddy
  class ClientTest < Minitest::Test
    def setup
      @api_key = "test_api_key"
      @client = Client.new(@api_key)
    end

    def test_initialization
      assert_equal @api_key, @client.instance_variable_get(:@api_key)
      assert_equal Faraday.default_adapter, @client.instance_variable_get(:@adapter)

      assert_nil @client.instance_variable_get(:@stubs)
    end

    def test_voter_list
      voter_list_resource = @client.voter_list

      assert_instance_of VoterListResource, voter_list_resource
    end
  end
end
