# Top100

This gem allows the user to interact with the Billboard's Top 100 via the command line interface. Users can acquire a real time list of trending songs and acquire more information about the artists responsible for the works. Information is acquired through the use of the Nokogiri gem and OpenUri in order to data scrape information from the Billboard website.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'top_100', :git => 'https://github.com/viparthasarathy/top-100.git'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install top_100

## Usage

After installation, execute the gem by inputting top_100 into the console. The user will now be able to interact with the gem and request more information about the Billboard Top 100 or read the biographical information about trending artists.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/top_100.
