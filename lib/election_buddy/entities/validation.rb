# frozen_string_literal: true

module ElectionBuddy
  class Validation
    def initialize(response)
      @response = response
    end

    def identifier
      @response["validation_identifier"] || "Not available"
    end

    def done?
      @response["error"].nil?
    end

    def error
      return nil if done?

      ErrorFormatter.format(@response["error"])
    end
  end
end
