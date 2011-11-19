require 'spec_helper'

describe Datatable::Request do
	include DatatableHelperMethods
	
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
	
	before :each do
		@columns = %W(problem year meet_round number)
		@opts = create_opts(@columns)
	end
		
	context "initialization methods" do
		describe "#initialize_basics" do
			before :each do
				@opts['iDisplayStart'] = "0"
				@opts['iDisplayLength'] = "10"
				@opts["iSortingCols"] = "0"
				@obj = Datatable::Request.new(@opts, false)
				@obj.initialize_basics
			end
	
			it "sets opts" do
				@obj.opts.should == @opts
			end

			it "sets sEcho" do
				@obj.sEcho.should == @opts["sEcho"]
			end
	
			it "sets iDisplayStart" do
				@obj.iDisplayStart.should == 0
			end
	
			it "sets iDisplayLength" do
				@obj.iDisplayLength.should == 10
			end
	
			it "sets iColumns" do
				@obj.iColumns.should == @columns.count - 1
			end
	
			it "sets sColumns" do
				@obj.sColumns.should == @columns
			end

			it "sets sSearch" do
				@obj.sSearch.should_not be_nil
			end
		
			it "sets iSortingCols" do
				@obj.iSortingCols.should == 0
			end
		end
	
		describe "#initialize_sorts" do
			before :each do
				@opts["iSortingCols"] = "2"
				@opts["iSortCol_0"] = "0"
				@opts["sSortDir_0"] = "asc"
				@opts["iSortCol_1"] = "2"
				@opts["sSortDir_1"] = "desc"
				@opts["bSortable_0"] = "true"
				@opts["bSortable_2"] = "true"
				@obj = Datatable::Request.new(@opts)
			end
	
			it "creates bSortables" do
				@obj.bSortables.should == [true, false, true, false]
			end
	
			it "creates iSortCols" do
				@obj.iSortCols.should == [0, 2]
			end
	
			it "creates sSortDirs" do
				@obj.sSortDirs.should == ["ASC", "DESC"]
			end		
			end #initialize_sorts
			
			describe "#initialize_searches" do
				before :each do
					@opts["bSearchable_0"] = "true"
					@opts["sSearch_0"] = "foo"
		
					@obj = Datatable::Request.new(@opts)
					@obj.initialize_basics
					@obj.initialize_searches
				end
			
				it "creates bSearchables" do
					@obj.bSearchables.should == [true, false, false, false]
				end
			
				it "creates bSearches" do
					@obj.bSearches.should == ["foo", "", "", ""]
				end
			
				it "creates sRegexes" do
					@obj.sRegexes.should == [false, false, false, false]
				end
			end #initialize_searches
			
			describe "#expand_opts" do
				before :each do
					@obj = Datatable::Request.new(@opts)
				end
				it "should call each of the initialize methods" do
					[:initialize_basics, :initialize_sorts].each do |meth|
						@obj.should respond_to(meth)
					end
					@obj.expand_opts
				end
			end
		end #initialization
		
		
		# describe "#construct_conditions" do
		# 	it "constructs a WHEREable string" do
		# 		@opts["sSearch_0"] = "foo"
		# 		@opts["bSearchable_0"] = "true"
		# 		@opts["bRegex_0"] = "false"
		# 	
		# 		@obj = Datatable::Request.new(@opts)
		# 		@obj.construct_conditions.should == "problem LIKE 'foo'"
		# 	end
		# 	it "constructs a WHEREable string" do
		# 		@opts["sSearch_0"] = "foo"
		# 		@opts["bSearchable_0"] = "true"
		# 		@opts["bRegex_0"] = "true"
		# 	
		# 		@obj = Datatable::Request.new(@opts)
		# 		@obj.construct_conditions.should == "problem ~ 'foo'"
		# 	end
		# end
		# 
		# describe "#construct_select" do
		# 	it "should be return a comma-delimited list of columns if there are no overrides" do
		# 		@obj = Datatable::Request.new(TestModel, @opts)
		# 		@obj.construct_select.should == @columns.join(',')
		# 	end
		# 
		# 	it "should look for replacements and fix up the select list" do
		# 		@opts["sColumns"] = "problem,year,meet_and_round,number"
		# 		@obj = Datatable::Request.new(TestModel, @opts)
		# 		@obj.construct_select.should == "problem,year,meet,round,number"
		# 	end
		# end
		# 
		# describe "#construct_order" do
		# 	it "creates an SQL fragment for the ORDER clause" do
		# 		make_sortable(@opts)
		# 		@obj = Datatable::Request.new(TestModel, @opts)
		# 		@obj.construct_order.should == "#{@columns[@opts['iSortCol_0']]} #{@opts['sSortDir_0'].upcase}"
		# 	end
		# 
		# 	it "uses overrides when provided" do
		# 		@opts["iSortingCols"] = 2
		# 		@opts["iSortCol_0"] = 1
		# 		@opts["sSortDir_0"] = "asc"
		# 		@opts["iSortCol_1"] = 2
		# 		@opts["sSortDir_1"] = "asc"
		# 		@obj = Datatable::Request.new(TestModel, @opts)
		# 		@obj.construct_order.should =~ /year ASC,\s*meet ASC,\s*round ASC/
		# 	end
		# end
		# 
		# describe "#args_for_find" do
		# 	before :each do
		# 		@obj = Datatable::Request.new(TestModel, @opts)
		# 		@args = @obj.args_for_find
		# 	end
		# 
		# 	describe ":limit" do
		# 		it "should be an integer" do
		# 			@args[:limit].should be_kind_of Integer
		# 		end
		# 	end
		# 
		# 	describe ":offset" do
		# 		it "should be an integer" do
		# 			@args[:offset].should be_kind_of Integer
		# 		end
		# 	end
		# 
		# 	describe ":conditions" do
		# 		it "shouldn't exist if not searchable" do
		# 			@args[:conditions].should be_nil
		# 		end
		# 
		# 		it "should exist if searchable" do
		# 			make_searchable(@opts)
		# 			@obj = Datatable::Request.new(@opts)
		# 			@obj.searchable?.should be_true
		# 			@args = @obj.args_for_find
		# 			@args[:conditions].should be_kind_of String
		# 		end
		# 	end
		# 
		# 	describe ":construct_order" do
		# 		it "shouldn't exist if not sortable" do
		# 			@obj = Datatable::Request.new(@opts)
		# 			@args = @obj.args_for_find
		# 			@args[:order].should be_nil
		# 		end
		# 	
		# 		it "should contain a string if sortable" do
		# 			make_sortable(@opts)
		# 			@obj = Datatable::Request.new(@opts)
		# 			@args = @obj.args_for_find
		# 			@args[:order].should be_kind_of String
		# 		end
		# 	end
				
end
