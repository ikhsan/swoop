# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'swoop/version'

Gem::Specification.new do |spec|
  spec.name          = "swoop_report"
  spec.version       = Swoop::VERSION
  spec.authors       = ["Ikhsan Assaat"]
  spec.email         = ["ikhsan.assaat@songkick.com"]

  spec.summary       = "Compare how swift swoops objective-c classes over time"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry", "~> 0.10.3"
  spec.add_development_dependency "coveralls"

  spec.add_runtime_dependency "thor", "~> 0.19"
  spec.add_runtime_dependency "xcodeproj", "~> 1.2"
  spec.add_runtime_dependency "git", "~> 1.3"
  spec.add_runtime_dependency "terminal-table", "~> 1.5"
end
