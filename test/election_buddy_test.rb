# frozen_string_literal: true

require "test_helper"

class ElectionBuddyTest < Minitest::Test
  def setup
    ElectionBuddy.configuration = nil
  end

  def test_configuration
    ElectionBuddy.configure do |config|
      config.api_key = "test_api_key"
    end

    assert_equal "test_api_key", ElectionBuddy.configuration.api_key
  end
end
