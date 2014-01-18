# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'signaling/version'

Gem::Specification.new do |spec|
  spec.name          = "signaling"
  spec.version       = Signaling::VERSION
  spec.authors       = ["Neer Friedman"]
  spec.email         = ["neerfri@gmail.com"]
  spec.description   = %q{Signaling maps REST-like APIs to ruby objects}
  spec.summary       = %q{Signaling maps REST-like APIs to ruby objects}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "activemodel", ">= 3.1.0"
  spec.add_dependency "activesupport", ">= 3.1.0"
  spec.add_dependency "virtus", ">= 1.0.0"
  spec.add_dependency "faraday"
  spec.add_dependency "faraday_middleware"
  spec.add_dependency "hashie"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "rack"
  spec.add_development_dependency "addressable"
end
