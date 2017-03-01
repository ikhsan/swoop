$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'pry'
require 'simplecov'
require 'coveralls'
Coveralls.wear!

# RSpec.configure do |config|
#   config.filter_run :focus => true
# end

require 'swoop'
require 'swoop/file_parser'
require 'swoop/entity'
require 'swoop/file_info'
require 'swoop/project'
require 'swoop/report'

PROJECT_FIXTURE_PATH = 'spec/fixture/Swoop/Swoop.xcodeproj'

SimpleCov.formatter = Coveralls::SimpleCov::Formatter
SimpleCov.start do
  add_filter 'spec'
end
