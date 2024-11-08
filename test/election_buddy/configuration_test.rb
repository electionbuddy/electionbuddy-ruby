# frozen_string_literal: true

require "test_helper"

module ElectionBuddy
  class ConfigurationTest < Minitest::Test
    def test_api_key_configuration
      config = Configuration.new
      assert_nil config.api_key, "API key should be nil by default"

      config.api_key = "test_api_key"
      assert_equal "test_api_key", config.api_key, "API key should be settable"
    end
  end
end
