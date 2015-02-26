# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'chewy_resque/version'

Gem::Specification.new do |spec|
  spec.name          = "chewy_resque"
  spec.version       = ChewyResque::VERSION
  spec.authors       = ["Vlad Bokov"]
  spec.email         = ["bokov.vlad@gmail.com"]
  spec.description   = %q{Resque integration for chewy and resque}
  spec.summary       = %q{Small helper gem that allows you to automatically run all chewy index updates in resque}
  spec.homepage      = ""
  spec.license       = "Apache V2"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'resque', '~> 1.24'
  spec.add_dependency 'chewy', '~> 0.5'
  spec.add_dependency 'mlanett-redis-lock'
  spec.add_dependency 'activesupport', '>= 3.2.0'

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "kaminari"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry-byebug"
  spec.add_development_dependency "codeclimate-test-reporter"
end
