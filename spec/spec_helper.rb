require 'simplecov'
SimpleCov.start

require 'rubygems'

ENV["RAILS_ENV"] = "test"

$LOAD_PATH << "." unless $LOAD_PATH.include?(".")
require 'logger'
require 'factory_girl_rails'

begin
  require "rubygems"
  require "bundler"

  if Gem::Version.new(Bundler::VERSION) <= Gem::Version.new("0.9.5")
    raise RuntimeError, "Your bundler version is too old." +
     "Run `gem install bundler` to upgrade."
  end

  # Set up load paths for all bundled gems
  Bundler.setup
rescue Bundler::GemNotFound
  raise RuntimeError, "Bundler couldn't find some gems." +
    "Did you run \`bundle install\`?"
end

Bundler.require
# require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require File.expand_path('../../lib/acts_as_datatable_source', __FILE__)

# require 'ammeter/init'

unless [].respond_to?(:freq)
  class Array
    def freq
      k=Hash.new(0)
      each {|e| k[e]+=1}
      k
    end
  end
end

db_name = ENV['DB'] || 'sqlite3'
database_yml = File.expand_path('../database.yml', __FILE__)

if File.exists?(database_yml)
  active_record_configuration = YAML.load_file(database_yml)
  
  ActiveRecord::Base.configurations = active_record_configuration
  config = ActiveRecord::Base.configurations[db_name]
  
  begin
    ActiveRecord::Base.establish_connection(db_name)
    ActiveRecord::Base.connection
  rescue
    case db_name
    when /mysql/      
      ActiveRecord::Base.establish_connection(config.merge('database' => nil))
      ActiveRecord::Base.connection.create_database(config['database'],  {:charset => 'utf8', :collation => 'utf8_unicode_ci'})
    when 'postgresql'
      ActiveRecord::Base.establish_connection(config.merge('database' => 'postgres', 'schema_search_path' => 'public'))
      ActiveRecord::Base.connection.create_database(config['database'], config.merge('encoding' => 'utf8'))
    end
    
    ActiveRecord::Base.establish_connection(config)
  end
    
  ActiveRecord::Base.logger = Logger.new(File.join(File.dirname(__FILE__), "debug.log"))
  ActiveRecord::Base.default_timezone = :utc
  
  ActiveRecord::Base.silence do
    ActiveRecord::Migration.verbose = false
    
    load(File.dirname(__FILE__) + '/schema.rb')
    load(File.dirname(__FILE__) + '/models.rb')
  end  
  
else
  raise "Please create #{database_yml} first to configure your database. Take a look at: #{database_yml}.sample"
end
# 
def clean_database!
  models = [TestModel]
  models.each do |model|
    ActiveRecord::Base.connection.execute "DELETE FROM #{model.table_name}"
  end
end

clean_database!

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }
Dir["#{File.dirname(__FILE__)}/factories/**/*.rb"].each { |f| require f }

# RSpec.configure do |config|
#   # == Mock Framework
#   #
#   # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
#   #
#   # config.mock_with :mocha
#   # config.mock_with :flexmock
#   # config.mock_with :rr
#   config.mock_with :rspec
# 
#   # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
#   config.fixture_path = "#{::Rails.root}/spec/fixtures"
# 
#   # If you're not using ActiveRecord, or you'd prefer not to run each of your
#   # examples within a transaction, remove the following line or assign false
#   # instead of true.
#   config.use_transactional_fixtures = true
# end

