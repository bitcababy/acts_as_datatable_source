module Datatable
	class Request
		attr_accessor :sEcho, :iDisplayStart, :iDisplayLength, :iColumns, :sColumns, :mDataProps
		attr_accessor :bSortables, :iSortingCols, :iSortCols, :sSortDirs
		attr_accessor :sSearch, :bRegex, :bSearchables, :bSearches, :sRegexes
		attr_accessor :select_string, :order_string, :where_string
		attr_accessor :opts

		def initialize(opts, expand=true)
			self.opts = opts
			self.expand_opts if expand
			return self
		end
		
		def expand_opts
			initialize_basics
			# initialize_replacements
			initialize_sorts
			initialize_searches
		end
		
		def initialize_basics
			self.sEcho = @opts["sEcho"]
			self.iDisplayStart = @opts["iDisplayStart"].to_i
			self.iDisplayLength = @opts["iDisplayLength"].to_i
			self.iColumns = @opts["iColumns"].to_i - 1
			self.sColumns = @opts["sColumns"].split(",")
			self.sSearch = @opts["sSearch"]
			self.iSortingCols = @opts["iSortingCols"].to_i
		end
		
		# def initialize_replacements
		# 	self.sReplacements = {}
		# 	@opts.each_pair do |k,v|
		# 		if k =~ /^sReplace:\s*(.*)$/ then
		# 			self.sReplacements[$1] = v
		# 		end
		# 	end
		# end

		def initialize_sorts
			self.bSortables = (0..@iColumns).collect { |i| @opts["bSortable_#{i}"] == "true" }

			self.iSortCols = []
			self.sSortDirs = []
			return if iSortingCols == 0

			@iSortingCols.times do |i|
				@iSortCols << @opts["iSortCol_#{i}"].to_i
				@sSortDirs << @opts["sSortDir_#{i}"].upcase
			end

		end

		def initialize_searches
			@bSearchables = []
			@bSearches = []
			@sRegexes = []
	
			(0..@iColumns).each do |i|
				@bSearchables << (@opts["bSearchable_#{i}"] == "true")
				@bSearches << @opts["sSearch_#{i}"]
				@sRegexes << (@opts["bRegex_#{i}"] == "true")
			end
		end


		# def searchable?
		# 	return true unless @sSearch.empty?
		# 	# return false unless @bSearchables.any? {|v| v}
		# 	(@bSearchables.count).times do |i|
		# 		return true if @bSearchables[i] && !@bSearches[i].empty?
		# 	end
		# 	return false
		# end
		# 
		# def sortable?
		# 	@iSortingCols > 0
		# end
		# 
		# def construct_order
		# 	res = (0..@iSortingCols - 1).collect do |i|
		# 		colNo = @iSortCols[i]
		# 		col = @sColumns[colNo]
		# 		puts col
		# 		s = @sReplacements[col]
		# 		if s = @sReplacements[col] then
		# 			s.split(',').join(" #{@sSortDirs[i]},")
		# 		else
		# 			@sColumns[colNo] + " " + @sSortDirs[i]
		# 		end
		# 	end
		# 	# puts "***Order is #{res}"
		# 	res.join(",")
		# end
		# 
		# def construct_conditions
		# 	res = (0..@iColumns - 1).collect do |i|
		# 		if @bSearchables[i] && !@bSearches[i].empty? then
		# 			if @sRegexes[i] then
		# 				"#{sColumns[i]} ~ '#{@bSearches[i]}'"
		# 			else 
		# 				"#{sColumns[i]} LIKE '#{@bSearches[i]}'"
		# 			end
		# 		else
		# 			nil
		# 		end
		# 	end
		# 	res.compact.join(" AND ")
		# end
		# 
		# def args_for_find
		# 	args = {select: @select_string, limit: @iDisplayLength, offset: @iDisplayStart}
		# 	args[:conditions] = self.construct_conditions if self.searchable?
		# 	args[:order] = self.construct_order if self.sortable?
		# 	return args
		# end
		

	end
end
