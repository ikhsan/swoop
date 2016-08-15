$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'pry'
require 'coveralls'
Coveralls.wear!

require 'swoop'
require 'swoop/entity_parser'
require 'swoop/entity'
require 'swoop/project'
require 'swoop/report'
