# frozen_string_literal: true

require "test_helper"

class Electionbuddy::TestRuby < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Electionbuddy::Ruby::VERSION
  end

  def test_it_does_something_useful
    assert false
  end
end
