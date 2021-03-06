# coding: utf-8

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fastlane/plugin/covfefe/version'

Gem::Specification.new do |spec|
  spec.name          = 'fastlane-plugin-covfefe'
  spec.version       = Fastlane::Covfefe::VERSION
  spec.author        = 'Jakob Jensen'
  spec.email         = 'jje@trifork.com'

  spec.summary       = 'A templating engine for generating common file structures.'
  # spec.homepage      = "https://github.com/<GITHUB_USERNAME>/fastlane-plugin-covfefe"
  spec.license       = "MIT"

  spec.files         = Dir["lib/**/*"] + %w(README.md LICENSE)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  # Don't add a dependency to fastlane or fastlane_re
  # since this would cause a circular dependency

  spec.add_dependency 'mustache', '~> 1.0'

  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'fastlane', '>= 2.29.0'
end
