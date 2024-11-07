# frozen_string_literal: true

module ElectionBuddy
  class VoterListResource < Resource
    def validate(vote_id)
      response = post_request("/api/v2/votes/voters/validations", vote_id: vote_id.to_i)

      Validation.new(response)
    end
  end
end
