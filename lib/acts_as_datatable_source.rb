require 'active_record'
require 'active_record/version'

require 'acts_as_datatable_source/version'
require 'acts_as_datatable_source/base'
require 'datatable/request'

if defined?(ActiveRecord::Base)
  ActiveRecord::Base.extend ActsAsDatatableSource::Base
else
	foo
end
