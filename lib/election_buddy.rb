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
require "election_buddy/configuration"
require "election_buddy/entities/validation/result"
require "election_buddy/entities/validation/line_error"
require "election_buddy/entities/validation/line_errors"
require "election_buddy/entities/validation/list_error"
require "election_buddy/entities/validation/list_errors"

# ElectionBuddy API client library
#
# @api public
# @example Configure the client
#   ElectionBuddy.configure do |config|
#     config.api_key = 'your-api-key'
#   end
module ElectionBuddy
  class << self
    # @return [Configuration] Current configuration
    attr_accessor :configuration

    # Configures the ElectionBuddy client
    #
    # @yield [config] Configuration instance to be modified
    # @yieldparam [Configuration] config The configuration instance
    def configure
      self.configuration ||= Configuration.new
      yield(configuration)
    end
  end
end
