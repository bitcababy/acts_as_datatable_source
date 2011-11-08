# #!/usr/bin/env rake
# begin
#   require 'bundler/setup'
# rescue LoadError
#   puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
# end
# begin
#   require 'rdoc/task'
# rescue LoadError
#   require 'rdoc/rdoc'
#   require 'rake/rdoctask'
#   RDoc::Task = Rake::RDocTask
# end
# 
# RDoc::Task.new(:rdoc) do |rdoc|
#   rdoc.rdoc_dir = 'rdoc'
#   rdoc.title    = 'ActsAsDatatableSource'
#   rdoc.options << '--line-numbers'
#   rdoc.rdoc_files.include('README.rdoc')
#   rdoc.rdoc_files.include('lib/**/*.rb')
# end
# 
# $:.unshift(File.dirname(__FILE__) + '/lib')
# Dir['gem_tasks/**/*.rake'].each { |rake| load rake }
# 
# Bundler::GemHelper.install_tasks
# 
# # require 'rspec/core/rake_task'
# # RSpec::Core::RakeTask.new('spec')
# task :default => [:spec, :cucumber]
# 
# require 'rake/clean'
# CLEAN.include %w(**/*.{log,pyc,rbc,tgz} doc)
# 
# 
# 
# 

# encoding: utf-8
require 'rubygems'
require 'bundler'
Bundler::GemHelper.install_tasks

$:.unshift(File.dirname(__FILE__) + '/lib')
Dir['gem_tasks/**/*.rake'].each { |rake| load rake }

task :default => [:spec, :cucumber]

require 'rake/clean'
CLEAN.include %w(**/*.{log,pyc,rbc,tgz} doc)
