$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "acts_as_datatable_source/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "acts_as_datatable_source"
  s.version     = ActsAsDatatableSource::VERSION
  s.authors     = ["Meredith Lesly"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "acts_as_datatable_source-#{s.version}"
  s.description = "TODO: Description of ActsAsDatatableSource."

	s.rdoc_options     = ["--charset=UTF-8"]

	s.rubygems_version = ">= 1.6.1"
  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {spec,features}/*`.split("\n")

  s.add_runtime_dependency 		"rails", "~> 3.1.1"
  s.add_runtime_dependency 		"json"
	s.add_development_dependency 		'gherkin', '~> 2.6.0'
	s.add_development_dependency 		'term-ansicolor', '>= 1.0.6'
 	s.add_development_dependency 'rspec', '~> 2.5'
  s.add_development_dependency 'ammeter', '~> 0.1.3'
  s.add_development_dependency 'sqlite3-ruby'
  s.add_development_dependency 'pg'
  s.add_development_dependency 'guard'
  s.add_development_dependency 'cucumber'
  s.add_development_dependency 'factory_girl_rails'
  s.add_development_dependency 'guard-rspec'
  s.add_development_dependency 'rb-fsevent'
  s.add_development_dependency 'haml'
  s.require_paths = ['lib']

end
