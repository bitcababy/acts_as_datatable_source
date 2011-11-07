module JsDatatable
	class Request
		attr_accessor :sEcho, :iDisplayStart, :iDisplayLength, :iColumns, :aColumns, :mDataProps
		attr_accessor :aSortables, :iSortingCols, :aSortCols, :aSortDirs
		attr_accessor :sSearch, :bRegex, :aSearchables, :aSearches, :aRegexes

		def initialize(opts)
			initialize_basics(opts)
			initialize_sorts(opts)
			initialize_searches(opts)
			return self
		end
	
		def initialize_basics(opts)
			self.sEcho = opts["sEcho"]
			self.iDisplayStart = opts["iDisplayStart"].to_i
			self.iDisplayLength = opts["iDisplayLength"].to_i
			self.iColumns = opts["iColumns"].to_i
			self.aColumns = opts["sColumns"].split(",")
			self.sSearch = opts["sSearch"]
			self.iSortingCols = opts["iSortingCols"].to_i
		end
	
		def initialize_sorts(opts)
			self.aSortCols = []
			self.aSortDirs = []
			self.aSortables = (0..@iColumns-1).collect { |i| opts["bSortable_#{i}"] == "true" }

			@iSortingCols.times do |i|
				@aSortCols << opts["iSortCol_#{i}"].to_i
				@aSortDirs << opts["sSortDir_#{i}"].upcase
			end
		end

		def initialize_searches(opts)
			@aSearchables = []
			@aSearches = []
			@aRegexes = []
		
			@iColumns.times do |i|
				@aSearchables << (opts["bSearchable_#{i}"] == "true")
				@aSearches << opts["sSearch_#{i}"]
				@aRegexes << (opts["bRegex_#{i}"] == "true")
			end
		end
	
		def args_for_find
			args = {select: self.select, limit: @iDisplayLength, offset: @iDisplayStart-1}
			args[:conditions] = self.conditions if self.searchable?
			args[:order] = self.order if self.sortable?
			return args
		end

		def searchable?
			return true unless @sSearch.empty?
			return false unless @aSearchables.any? {|v| v}
			(@aSearchables.count).times do |i|
				return true if @aSearchables[i] && !aSearches[i].empty?
			end
			return false
		end
	
		def sortable?
			self.iSortingCols > 0
		end
	
		def select
			@aColumns.join(",")
		end

		def order
			res = (0..@iSortingCols-1).collect do |i|
				@aColumns[@aSortCols[i]] + " " + @aSortDirs[i]
			end
			res.join(",")
		end
	
		def conditions
			res = (0..@iColumns-1).collect do |i|
				if @aSearchables[i] && !@aSearches[i].empty? then
					if @aRegexes[i] then
						"#{aColumns[i]} ~ #{@aSearches[i]}"
					else 
						"#{aColumns[i]} LIKE '#{@aSearches[i]}'"
					end
				else
					nil
				end
			end
			res.compact.join(" AND ")
		end
	end
end