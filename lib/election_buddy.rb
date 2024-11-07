# frozen_string_literal: true

require "faraday"
require "faraday/middleware"
require "json"

require "election_buddy/version"
require "election_buddy/client"
require "election_buddy/error"
require "election_buddy/resource"
require "election_buddy/resources/voter_list_resource"
require "election_buddy/entities/validation"
require "election_buddy/error_formatter"

module ElectionBuddy
end
