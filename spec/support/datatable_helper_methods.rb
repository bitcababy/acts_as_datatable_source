module DatatableHelperMethods
	def create_opts(columns)
		opts = {
			"sEcho"=>"1",
			"iColumns"=>columns.count,
			"sColumns"=> columns.join(","),
			"iDisplayStart"=>"1",
			"iDisplayLength"=>"10",
			"sSearch"=>"",
			"bRegex"=>"false",
			"sSearch_0"=>"",
			"bRegex_0"=>"false",
			"bSearchable_0"=>"true",
			"sSearch_1"=>"",
			"bRegex_1"=>"false",
			"bSearchable_1"=>"true",
			"iSortingCols"=>"1",
			"iSortCol_0"=>"1",
			"sSortDir_0"=>"asc",
			"bSortable_0"=>"false",
			"bSortable_1"=>"true",
		}
		return opts
	end
end
