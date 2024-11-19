# frozen_string_literal: true

module ElectionBuddy
  # Handles voter list validation operations
  #
  # @example
  #   resource = VoterListResource.new(client)
  #   validation = resource.validate(123)
  #   result = resource.get_validation_result(validation.identifier)
  #
  class VoterListResource < Resource
    def import(vote_id, voters, append_mode: false)
      response = post_request("/api/v2/votes/voters/importations", vote_id: vote_id.to_i, voters: voters, append_mode: append_mode)

      Importation.new(response)
    end

    # Initiates a validation for a given vote
    #
    # @param vote_id [Integer] The ID of the vote to validate
    # @return [Validation] The validation response
    def validate(vote_id)
      response = post_request("/api/v2/votes/voters/validations", vote_id: vote_id.to_i)

      Validation.new(response)
    end

    # Retrieves the validation results
    #
    # @param identifier [String] The validation identifier
    # @param page [Integer, nil] The page number for paginated results (optional, default: 1)
    # @param per_page [Integer, nil] The number of items per page (optional, default: 10)
    # @return [Validation::Result] The validation results
    def get_validation_result(identifier, page: 1, per_page: 10)
      params = { "identifier" => identifier, "page" => page, "per_page" => per_page }
      response = get_request("/api/v2/votes/voters/validations", params)

      Validation::Result.new(response)
    end
  end
end
