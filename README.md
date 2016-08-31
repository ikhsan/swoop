# Swoop : Swift and Objective-C comparison reporter

[![Gem](https://img.shields.io/gem/v/swoop_report.svg)][rubygems]
[![Build Status](http://img.shields.io/travis/ikhsan/swoop/master.svg)][travis]
[![Coverage Status](http://img.shields.io/coveralls/ikhsan/swoop/master.svg)][coveralls]

[rubygems]: https://rubygems.org/gems/swoop_report
[travis]: https://travis-ci.org/ikhsan/swoop
[coveralls]: https://coveralls.io/github/ikhsan/swoop?branch=master

Track your swift code in your Xcode codebase through time. It can go back in time from your git repository and make a comparison report.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'swoop_report'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install swoop_report

## Usage

To print the comparison report inside your console, just run `swoop` command with two required options:

```bash
$ swoop --path <path> --dir <dir>
```

- `path` is your path to your `.xcodeproj` and
- `dir` is your directory inside your Xcode project

As default options, this will list the last 8 tags, collect information from each tag, collate it into a report, and then present it as a table inside your console.

### Example

Say you have your awesome project inside `YourAwesomeProject` folder called `AwesomeProject.xcodeproj`. You open the project, and you have organised your files in Xcode project navigator to look something like this :

```
+ AwesomeProject
+- Classes
+--- Model
+--- View
+--- Controller
+--- Network
+- Assets
+- Frameworks
+- Products
```

Say, you want to compare all of the classes then run :

```bash
$ swoop --path '~/YourAwesomeProject/AwesomeProject.xcodeproj' --dir 'Classes'
```

Or, if you want to compare only files inside `Controller`, run :

```bash
$ swoop --path '~/YourAwesomeProject/AwesomeProject.xcodeproj' --dir 'Classes/Controller'
```

### Options

#### Path (`--path`)

Specify the path to the `.xcodeproj` file. (This is required)

#### Directory (`--dir`)

Specify which directory where the files that you want to compare based on Xcode project navigator. (This is required)

#### Tags (`--tags`)

Specify a number of how many tags you want to include for comparison. For example, if you want to include the last 10 tags you would run:

```bash
$ swoop --path '~/YourAwesomeProject/AwesomeProject.xcodeproj' --dir 'Classes' --tags 10
```

#### Filter Tag (`--filter_tag`)

Specify a regular expression that will be applied to tag names. This only applies if tags is used. For example, if you only want to include tags that look like `v1.0.0`, then you would run:

```bash
$ swoop --path '~/YourAwesomeProject/AwesomeProject.xcodeproj' --dir 'Classes' --tags 10 --filter_tag 'v\d+.\d+.\d+'
```

#### Weeks (`--weeks`)

Specify a number of how many weeks you want to include for comparison. For example, if you want to include the last 30 weeks, run :

```bash
$ swoop --path '~/YourAwesomeProject/AwesomeProject.xcodeproj' --dir 'Classes' --weeks 30
```

Note: If both `--tags` and `--weeks` are specified, weeks will take priority.

#### Renderer (`--render`)

Specify how do you render the reports. Available renderers are `table`, `csv` and `chart`

##### Table

This renders a table in your console. Table is used if `--render` is not specified.

```bash
$ swoop --path '~/YourAwesomeProject/AwesomeProject.xcodeproj' --dir 'Classes'
# or
$ swoop --path '~/YourAwesomeProject/AwesomeProject.xcodeproj' --dir 'Classes' --render table
```

will output this table in your console

![table](/screenshots/table.png?raw=true)


##### CSV

This will export your report as a csv file in root.

```bash
$ swoop --path '~/YourAwesomeProject/AwesomeProject.xcodeproj' --dir 'Classes' --render csv
```

##### Chart

This will export your report as a chart in a webpage. It creates an `html` folder in root with the page `index.html` inside of it.

```bash
$ swoop --path '~/YourAwesomeProject/AwesomeProject.xcodeproj' --dir 'Classes' --render chart
```

will output a chart in `./html/index.html`

![chart](/screenshots/chart.png?raw=true)

## Contributing

Feel free to put any ideas, questions or bug reports by [creating issues](https://github.com/ikhsan/swoop/issues/new). If you think you have a great idea for any improvement we'd be really happy to receive any pull request (refer to **Development** section to setup in your local machine).

### Development

Clone this repository and get into the directory.

```bash
# Install dependencies
$ bin/setup
# Run the tests
$ rake spec
# (Optional) run interactive console for experimentation
$ bin/console
```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
