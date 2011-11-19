module DatatableHelperMethods
	def create_opts(columns)
		opts = {
			"sEcho"=>"1",
			"iColumns"=>columns.count,
			"sColumns"=> columns.join(','),
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
	
	
end
