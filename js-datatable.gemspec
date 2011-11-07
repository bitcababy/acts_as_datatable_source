$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "js-datatable/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "js-datatable"
  s.version     = JsDatatable::VERSION
  s.authors     = ["Meredith Lesly"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of JsDatatable."
  s.description = "TODO: Description of JsDatatable."

  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")

  s.add_dependency "rails", "~> 3.1.1"

  s.add_development_dependency "sqlite3"
  s.add_runtime_dependency 'rails'
 	s.add_development_dependency 'rspec', '~> 2.5'
  s.add_development_dependency 'ammeter', '~> 0.1.3'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'mysql2', '< 0.3'
  s.add_development_dependency 'pg'
  s.add_development_dependency 'guard'
  s.add_development_dependency 'guard-rspec'
  s.require_paths = ['lib']

end
