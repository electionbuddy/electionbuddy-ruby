# frozen_string_literal: true

module ElectionBuddy
  # @api public
  # Base error class for ElectionBuddy exceptions
  #
  # @example Raising a custom error
  #   raise ElectionBuddy::Error, "Something went wrong"
  #
  # @since 0.1.0
  class Error < StandardError
  end
end
