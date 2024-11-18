# frozen_string_literal: true

module ElectionBuddy
  # Represents a validation operation response from the ElectionBuddy API
  # This class handles both successful and failed validation responses
  #
  # @example
  #   validation = Validation.new(response_hash)
  #   validation.done? #=> true/false
  #
  class Validation
    # @param response [Hash] The raw API response containing validation details
    def initialize(response)
      @response = response
    end

    # Returns the unique identifier for this validation
    #
    # @return [String] The validation identifier or "Not available" if not present
    def identifier
      @response["validation_identifier"] || "Not available"
    end

    # Checks if the validation completed successfully without errors
    #
    # @return [Boolean] true if validation completed without errors, false otherwise
    def done?
      @response["error"].nil?
    end

    # Returns formatted error message if validation failed
    #
    # @return [String, nil] Formatted error message or nil if validation was successful
    def error
      return nil if done?

      ErrorFormatter.format(@response["error"])
    end
  end
end
