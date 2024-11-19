# frozen_string_literal: true

module ElectionBuddy
  # Represents an importation operation for voter lists
  #
  # @example
  #   importation = Importation.new(response)
  #   if importation.done?
  #     puts "Import successful: #{importation.identifier}"
  #   else
  #     puts "Import failed: #{importation.error}"
  #   end
  #
  class Importation
    # @param response [Hash] The API response containing importation details
    def initialize(response)
      @response = response
    end

    # Returns the identifier for this importation
    #
    # @return [String] The importation identifier or "Not Available"
    def identifier
      @response["importation_identifier"] || "Not Available"
    end

    # Checks if the importation completed successfully
    #
    # @return [Boolean] true if importation was successful, false otherwise
    def done?
      @response["error"].nil?
    end

    # Returns the error message if importation failed
    #
    # @return [String, nil] The formatted error message or nil if importation was successful
    def error
      return nil if done?

      ErrorFormatter.format(@response["error"])
    end
  end
end
