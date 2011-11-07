require 'active_record'
require 'active_record/version'

require 'js-datatable/core'
require 'js-datatable/version'
require 'js-datatable/request'
require 'js-datatable/object'

if defined?(ActiveRecord::Base)
	ActiveRecord::Base.extend JsDatatable::Core
end