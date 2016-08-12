# Swoop

Swift to Objective-C conversion reporter. Track your swift code in your Xcode codebase. It can go back in time from your git repository and make a comparison report.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'swoop'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install swoop

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

```bash
$ bundle exec swoop report --path <path> --folder 'Classes/Models'
```

## TODOs

- [x] renderer
  - [x] csv
  - [x] table
  - [ ] graph/html/js representation of the report
- [ ] Time machine
  - [ ] get latest n weeks
  - [ ] get current branch
- [ ] tests and code coverage

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ikhsan/swoop.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
