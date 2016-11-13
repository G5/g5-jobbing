# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'g5/jobbing/version'

Gem::Specification.new do |spec|
  spec.name        = "g5-jobbing"
  spec.version     = G5::Jobbing::VERSION
  spec.authors     = ["Perry Hertler"]
  spec.email       = ["perry@hertler.org"]
  spec.summary     = %q{Uses the g5-jobs service to manage and organize jobs.}
  spec.description = %q{Uses the g5-jobs service to manage and organize jobs.}
  spec.homepage    = ""
  spec.license     = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", ">= 3.1"
  spec.add_development_dependency "rspec-its"
  spec.add_development_dependency "pry-nav"

  spec.add_dependency "activesupport"
  spec.add_dependency "httparty"
  spec.add_dependency "virtus"
end

