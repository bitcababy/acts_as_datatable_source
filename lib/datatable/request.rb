module Datatable
	class Request
		attr_accessor :sEcho, :iDisplayStart, :iDisplayLength, :iColumns, :sColumns, :mDataProps
		attr_accessor :bSortables, :iSortingCols, :iSortCols, :sSortDirs
		attr_accessor :sSearch, :bRegex, :bSearchables, :bSearches, :sRegexes
		attr_accessor :opts

		def initialize(opts, expand=true)
			self.opts = opts
			self.expand_opts if expand
			return self
		end
		
		def expand_opts
			initialize_basics
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


	end
end
