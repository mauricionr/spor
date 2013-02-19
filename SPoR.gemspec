# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'spor/version'

Gem::Specification.new do |gem|
  gem.name = 'spor'
  gem.version = SPoR::VERSION
  gem.authors = %w(mgoldbach)
  gem.email = %w(mgoldbach@agile-is.de)
  gem.description = 'Common interface to create SharePoint 2013 Apps with Ruby on Rails'
  gem.summary = 'SPoR - SharePoint on Rails. Create SharePoint 2013 Apps with Ruby on Rails'
  gem.homepage = 'http://www.agile-is.de'

  gem.files = `git ls-files`.split($/)
  gem.executables = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  #Dependencies
  gem.add_dependency 'jwt'
  gem.add_dependency 'rest-client'
  gem.add_dependency 'httpi'

  #Development dependencies
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'rake'
end
