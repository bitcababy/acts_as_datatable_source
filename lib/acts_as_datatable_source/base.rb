require 'datatable/request'

module ActsAsDatatableSource
	module Base
		def acts_as_datatable_source?
			false
		end
		
		def acts_as_datatable_source
			unless acts_as_datatable_source?
				class_eval do
					self.class_variable_set(:@@ds_transforms, {})
					
					def self.select_for_datatable(opts)
						dr = Datatable::Request.new(opts)
						self.find :all, self.args_for_find(dr)
					end

					def self.count_for_datatable(opts)
						dr = Datatable::Request.new(opts)
						self.count # :conditions => self.construct_conditions(dr)
					end


					def self.construct_for_json(opts)
						dr = Datatable::Request.new(opts)
						ret = {"sEcho" => dr.sEcho, 'iTotalRecords' => self.count, 'sColumns' => dr.sColumns.join(",")}

						objects = select_for_datatable(opts)
						ret["iTotalDisplayRecords"] = self.count_for_datatable(opts)
						ret["aaData"] = objects.collect do |object|
							dr.sColumns.collect {|col| object.fetch_attribute(col)}
						end
						return ret
					end

					def self.args_for_find(dr)
						args = {select: self.construct_select(dr), limit: dr.iDisplayLength, offset: dr.iDisplayStart}
						# args[:conditions] = self.construct_conditions(dr) if self.searchable?
						args[:order] = self.construct_order(dr) if self.sortable?(dr)
						return args
					end

					def self.acts_as_datatable_source?
						true
					end
					
					def fetch_attribute(name)
						if self.has_attribute? name
							self[name]
						else
							self.send name
						end
					end

					def self.datatable_source_transforms(args)
						@@ds_transforms = args
					end

					def self.construct_select(dr)
						cols = dr.sColumns.collect { |col| self.ds_select_for col}
						return cols.join(',')
					end
					
					def self.sortable?(dr)
						(dr.iSortingCols > 0) || !dr.sSearch.empty?
					end
					
					def self.construct_order(dr)
						res = (0..dr.iSortingCols - 1).collect do |i|
							col = dr.sColumns[dr.iSortCols[i]]
							s = self.ds_order_for col
							dir = dr.sSortDirs[i]
							s.split(",").join(" #{dir},") + " " + dir
						end
						# puts "***Order is #{res}"
						res.join(",")
					end
					
					# 	def self.construct_conditions
					# 		res = (0..@iColumns - 1).collect do |i|
					# 			if @bSearchables[i] && !@bSearches[i].empty? then
					# 				if @sRegexes[i] then
					# 					"#{sColumns[i]} ~ '#{@bSearches[i]}'"
					# 				else 
					# 					"#{sColumns[i]} LIKE '#{@bSearches[i]}'"
					# 				end
					# 			else
					# 				nils
					# 			end
					# 		end
					# 		res.compact.join(" AND ")
					# 	end
						

				end
			end
		end

	end
end #ActsAsDatatableSource
