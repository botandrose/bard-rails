# Bard::Rails

`bard-rails` is a meta gem that only requires other gems that are in use in all of BARD's Rails projects:

* bard: CLI tool for deployment and etc
* bard-rake: rake tasks for testing and db management
* bard-static: zero-conf static pages and mockups
* bard-staging_banner: visual page annotation for staging environment, including links to view "sent" emails
* bard-file_field: a modern replacement for <input type="file">
* slim-rails: our preferred templating language
* labelled_form: some nice label shortcuts for the Rails form builder
* rack-disable_css_animations: automatically remove CSS animations in the test environment, for more reliable tests

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'bard-rails'
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/bard-rails.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
