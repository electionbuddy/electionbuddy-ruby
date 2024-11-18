# frozen_string_literal: true

module ElectionBuddy
  # Formats error messages from hash responses
  #
  # @example
  #   ErrorFormatter.format({ "email" => ["is invalid", "is required"] })
  #   #=> "Email: is invalid, is required"
  #
  class ErrorFormatter
    # Formats error messages from a hash into a human-readable string
    #
    # @param error_hash [Hash, nil] Hash containing error keys and messages
    # @return [String, nil] Formatted error message or nil if no errors
    def self.format(error_hash)
      return if error_hash.nil? || error_hash.empty?

      error_hash.map do |key, value|
        formatted_key = key.gsub("_", " ").split.map(&:capitalize).join(" ")
        formatted_value = value.is_a?(Array) ? value.join(", ") : value
        "#{formatted_key}: #{formatted_value}"
      end.join(", ")
    end
  end
end
