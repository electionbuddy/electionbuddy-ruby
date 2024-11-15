# ElectionBuddy Ruby

A Ruby client for interacting with the [ElectionBuddy API](https://api.electionbuddy.com).
Explore the complete documentation at [https://electionbuddy.github.io/electionbuddy-ruby](https://electionbuddy.github.io/electionbuddy-ruby).

## Installation

Install the gem and add it to the application's Gemfile by executing:

    bundle add electionbuddy-ruby

If bundler is not being used to manage dependencies, install the gem by executing:

    gem install electionbuddy-ruby

Alternatively, add the gem to the Gemfile:

```ruby
gem 'electionbuddy-ruby'
```

## Usage

Ensure you have an API key from Electionbuddy. You can configure the API key globally or initialize the client directly with the API key.

### Global Configuration

#### Example in a Rails application

Create an initializer file in `config/initializers/electionbuddy.rb` and add the following code:

```ruby
ElectionBuddy.configure do |config|
  config.api_key = Rails.application.credentials.electionbuddy[:api_key]
end
```

#### Client Initialization

You can now initialize the client without passing the API key if it has been configured globally:

```ruby
client = ElectionBuddy::Client.new
```

Alternatively, you can still pass the API key directly during initialization. If the API key is passed during initialization, it will take precedence over the global configuration.

```ruby
client = ElectionBuddy::Client.new(api_key: 'your-api-key')
```

### Voter List Validation

To validate a voter list, use the `voter_list.validate(vote_id)` method:

```ruby
validation = client.voter_list.validate(1)

if validation.done?
  puts "Validation completed successfully! Identifier: #{validation.identifier}"
else
  puts "Validation failed: #{validation.error}"
end
```

### Get the Validation Result

Once you have a validation identifier, you can check the validation results. 

```ruby
begin
  validation_result = client.voter_list.validation_result('ae0a1724-9791-4bb2-8331-6d4e55a9b7c8')
  if validation_result.valid?
    puts "The voter list is valid!"
  else
    puts "The voter list is invalid!"
    puts "Total errors count: #{validation_result.total_errors_count}"
  end
rescue ElectionBuddy::Error => e
  puts "Something went wrong: #{e.message}"
end
```

The voter list validation can have two types of errors:

1. **List-level errors**: Affect the entire voter list (e.g., missing required columns)
2. **Line-level errors**: Affect specific lines in the voter list (e.g., invalid email format)

#### List-Level Errors

List-level errors can be retrieved using the `list_errors` method.

```ruby
if validation_result.list_errors.any?
  puts "List-level errors:"
  validation_result.list_errors.each do |list_error|
    puts "Error message: #{list_error.error_message}"
  end
end
```

#### Line-Level Errors

Line-level errors are paginated. You can specify the page number and the number of errors per page.
If you don't specify the page number and the number of errors per page, the default values are 1 and 10, respectively.

```ruby
validation_result = client.voter_list.validation_result('ae0a1724-9791-4bb2-8331-6d4e55a9b7c8', page: 2, per_page: 10)
line_errors = validation_result.line_errors
puts "There is a total of #{line_errors.total} line-level errors."
puts "The current page is #{line_errors.page}."
puts "There are #{line_errors.per_page} errors per page."
puts "There are #{line_errors.total_pages} pages in total."
```

PS: The `list_errors` object is always available, regardless of the line-level errors pagination.

To iterate over the line-level errors, you can use the following code:

```ruby
if line_errors.any?
  puts "Line-level errors for page #{line_errors.page}:"
  line_errors.each do |line_error|
    puts "Line identifier: #{line_error.voter_information_line_id}"
    puts "Error messages:"
    line_error.each do |line_error|
      puts "Error messages #{line_error.error_messages}"
    end
  end
end
```

### Possible API Errors

The following errors may be raised by the API:

- **400**: Malformed request.
- **401**: Invalid authentication credentials.
- **403**: Unauthorized.
- **404**: Resource not found.
- **429**: Your request exceeded the API rate limit.
- **500**: We were unable to perform the request due to server-side problems.

Each error will raise an `Error` exception with a message detailing the status code and the error message returned by the API.

## Documentation

The complete documentation for this gem is available at: https://electionbuddy.github.io/electionbuddy-ruby

You can also generate the documentation locally using:

```bash
yard doc
yard server
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/electionbuddy/electionbuddy-ruby.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
