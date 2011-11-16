module Datatable
	class Request
		attr_accessor :sEcho, :iDisplayStart, :iDisplayLength, :iColumns, :sColumns, :mDataProps
		attr_accessor :bSortables, :iSortingCols, :iSortCols, :sSortDirs
		attr_accessor :sSearch, :bRegex, :bSearchables, :bSearches, :sRegexes
		attr_accessor :select_string, :order_string, :where_string
		attr_accessor :opts

		def initialize(opts)
			self.opts = opts
			initialize_basics
			initialize_sorts
			initialize_searches
			@select_string = self.construct_select
			@order_string = self.construct_order
			@where_string = self.construct_conditions
			return self
		end

		def initialize_basics
			self.sEcho = @opts["sEcho"]
			self.iDisplayStart = @opts["iDisplayStart"].to_i
			self.iDisplayLength = @opts["iDisplayLength"].to_i
			self.iColumns = @opts["iColumns"].to_i
			self.sColumns = @opts["sColumns"].split(",")
			self.sSearch = @opts["sSearch"]
			self.iSortingCols = @opts["iSortingCols"].to_i
		end

		def initialize_sorts
			self.bSortables = (0..@iColumns-1).collect { |i| @opts["bSortable_#{i}"] == "true" }

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
	
			@iColumns.times do |i|
				@bSearchables << (@opts["bSearchable_#{i}"] == "true")
				@bSearches << @opts["sSearch_#{i}"]
				@sRegexes << (@opts["bRegex_#{i}"] == "true")
			end
		end

		def args_for_find
			args = {select: @select_string, limit: @iDisplayLength, offset: @iDisplayStart}
			args[:conditions] = self.construct_conditions if self.searchable?
			args[:order] = self.construct_order if self.sortable?
			return args
		end

		def searchable?
			return true unless @sSearch.empty?
			# return false unless @bSearchables.any? {|v| v}
			(@bSearchables.count).times do |i|
				return true if @bSearchables[i] && !@bSearches[i].empty?
			end
			return false
		end

		def sortable?
			@iSortingCols > 0
		end

		def construct_select
			cols = @sColumns
			cols = (0..iColumns-1).collect do |i|
				sSelect = @opts["sSelect_#{i}"]
				if sSelect then
					sSelect
				else
					@sColumns[i]
				end
			end
			return cols.join(',')
		end

		def construct_order
			res = (0..@iSortingCols - 1).collect do |i|
				sort = @opts["sSort_#{i}"]
				if sort then
					sort.gsub("DIR", @sSortDirs[i])
				else
					@sColumns[@iSortCols[i]] + " " + @sSortDirs[i]
				end
			end
			res.join(",")
		end

		def construct_conditions
			res = (0..@iColumns - 1).collect do |i|
				if @bSearchables[i] && !@bSearches[i].empty? then
					if @sRegexes[i] then
						"#{sColumns[i]} ~ '#{@bSearches[i]}'"
					else 
						"#{sColumns[i]} LIKE '#{@bSearches[i]}'"
					end
				else
					nil
				end
			end
			res.compact.join(" AND ")
		end

	end
end
