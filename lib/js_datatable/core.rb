module JsDatatable
	module Core
		def acts_as_datatable_object?
			false
		end
		
		def acts_as_datatable_object
			unless acts_as_datatable_object?
				class_eval do
					include JsTable::Object
				end
			end
		end #acts_as_datatable_object

	end #Core
end #JsDatatable
