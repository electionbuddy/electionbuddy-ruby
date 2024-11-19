# frozen_string_literal: true

module ElectionBuddy
  class Importation
    def initialize(response)
      @response = response
    end

    def identifier
      @response["importation_identifier"] || "Not Available"
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
