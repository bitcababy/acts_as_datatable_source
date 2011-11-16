require 'datatable/request'

module ActsAsDatatableSource
	module Base
		def acts_as_datatable_source?
			false
		end
		
		def acts_as_datatable_source
			unless acts_as_datatable_source?
				class_eval do

					def self.select_for_datatable(opts)
						dr = Datatable::Request.new(opts)
						self.find :all, dr.args_for_find
					end

					def self.count_for_datatable(opts)
						dr = Datatable::Request.new(opts)
						self.count :conditions => dr.construct_conditions
					end

					def fetch_attribute(name)
						if self.has_attribute? name
							self[name]
						else
							self.send name
						end
					end

					def self.construct_for_json(opts)
						dr = Datatable::Request.new(opts)
						objects = select_for_datatable(opts)
						ret = {"sEcho" => dr.sEcho, 'iTotalRecords' => self.count, 'sColumns' => dr.sColumns.join(",")}

						ret["iTotalDisplayRecords"] = self.count_for_datatable(opts)
						ret["aaData"] = objects.collect do |object|
							dr.sColumns.collect {|col| object.fetch_attribute(col)}
						end
						return ret
					end

					def self.acts_as_datatable_source?
						true
					end

				end
			end
		end

	end
end #ActsAsDatatableSource

