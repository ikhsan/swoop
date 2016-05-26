# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'swoop/version'

Gem::Specification.new do |spec|
  spec.name          = "swoop"
  spec.version       = Swoop::VERSION
  spec.authors       = ["Ikhsan Assaat"]
  spec.email         = ["ikhsan.assaat@songkick.com"]

  spec.summary       = "Compare how swift swoops objective-c classes over time"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry", "~> 0.10.3"

  spec.add_runtime_dependency "thor", "~> 0.19"
  spec.add_runtime_dependency "xcodeproj", "~> 0.28"
  spec.add_runtime_dependency "git", "~> 1.3"
end
