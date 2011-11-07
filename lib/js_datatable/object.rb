module JsTable
	module Object
		module ClassMethods
			def select_for_datatable(opts)
				dr = JsDatatable::Request.new(opts)
				self.find :all, dr.args_for_find
			end

			def count_for_datatable(opts)
				dr = JsDatatable::Request.new(opts)
				self.count :conditions => dr.conditions
			end

			def construct_for_json(opts)
				dr = JsDatatable::Request.new(opts)
				objects = select_for_datatable(opts)
				ret = {"sEcho" => dr.sEcho, 'iTotalRecords' => self.count, 'sColumns' => dr.select }

				ret["iTotalDisplayRecords"] = self.count_for_datatable(opts)
				ret["aaData"] = objects.collect do |problem|
					dr.aColumns.collect {|col| problem[col]}
				end

				return ret
			end
		end # ClassMethods
	end #Object
end # JsTable

		