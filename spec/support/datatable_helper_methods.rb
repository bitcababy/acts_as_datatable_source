module DatatableHelperMethods
	def create_opts(columns)
		opts = {
			"sEcho"=>"1",
			"iColumns"=>columns.count,
			"sColumns"=> columns.join(","),
			"iDisplayStart"=>"0",
			"iDisplayLength"=>"10",
			"sSearch"=>"",
			"bRegex"=>"false",
			"iSortingCols"=>"0",
			}
		columns.count.times do |i|
			opts["bSortable_#{i}"] = "false"
			opts["bSearchable_#{i}"] = "false"
			opts["bRegex_#{i}"] = "false"
			opts["sSearch_#{i}"] = ""
		end		
		return opts
	end
	
	def make_searchable(opts)
		opts["iSearchCols"] = "1"
		opts["sSearch"] = ""
		opts["bSearchable_0"] = "true"
		opts["sSearch_0"] = "foo"
	end
	
	def make_sortable(opts)
		opts["iSortingCols"] = "1"
		opts["iSortCol_0"] = 0
		opts["sSortDir_0"] = "asc"
	end
	
end
