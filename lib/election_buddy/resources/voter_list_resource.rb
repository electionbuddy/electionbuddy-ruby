# frozen_string_literal: true

module ElectionBuddy
  class VoterListResource < Resource
    def validate(vote_id)
      response = post_request("/api/v2/votes/voters/validations", vote_id: vote_id.to_i)

      Validation.new(response)
    end

    def get_validation_result(identifier, page: 1, per_page: 10)
      params = { "identifier" => identifier, "page" => page, "per_page" => per_page }
      response = get_request("/api/v2/votes/voters/validations", params)

      Validation::Result.new(response)
    end
  end
end
