# frozen_string_literal: true

module ElectionBuddy
  class ErrorFormatter
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
