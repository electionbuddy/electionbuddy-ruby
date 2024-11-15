# frozen_string_literal: true

module ElectionBuddy
  class Resource
    def initialize(connection)
      @connection = connection
    end

    def get_request(url, params = {}, headers = {}, &block)
      handle_response(@connection.get(url, params, headers, &block))
    end

    def post_request(url, body = {}, headers = {}, &block)
      handle_response(@connection.post(url, body, headers, &block))
    end

    private

    def handle_response(response)
      return response.body if response.success? || [422, 423].include?(response.status)

      raise_error(response.status, ErrorFormatter.format(response.body))
    end

    def raise_error(status, formatted_error)
      base_message = error_messages(status)
      message = if formatted_error
                  "Error #{status}: #{base_message} - #{formatted_error}."
                else
                  "Error #{status}: #{base_message}."
                end

      raise Error, message
    end

    def error_messages(status)
      messages = {
        400 => "Malformed request",
        401 => "Invalid authentication credentials",
        403 => "Unauthorized",
        404 => "Resource not found",
        429 => "Your request exceeded the API rate limit",
        500 => "We were unable to perform the request due to server-side problems"
      }
      messages.fetch(status, "Unexpected status code.")
    end
  end
end
