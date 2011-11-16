require 'spec_helper'

describe Datatable::Request do
	include DatatableHelperMethods
	before :each do
		@columns = %W(problem year meet_round number)
		@opts = create_opts(@columns)
	end
		
	context "initialization" do
		describe "#initialize_basics" do
			before :each do
				@opts['iDisplayStart'] = "0"
				@opts['iDisplayLength'] = "10"
				@obj = Datatable::Request.new(@opts)
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
				@obj.iColumns.should == @columns.count
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
		
			it "shouldn't be sortable" do
				@obj.sortable?.should be_false
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
	end #initialization
	
	context "searchable-related methods" do
		describe "#searchable?" do
			it "should return false if there's nothing to search for" do
				@obj = Datatable::Request.new(@opts)
				@obj.searchable?.should be_false
			end
			it "should return true if any bSearchables is true and the search string isn't empty" do
				make_searchable(@opts)
				@obj = Datatable::Request.new(@opts)
				@obj.searchable?.should be_true
			end
			it "should return true if sSearch isn't empty" do
				@opts["sSearch"] = "foo"
				@obj = Datatable::Request.new(@opts)
				@obj.searchable?.should be_true
			end
		end
	end

	describe "#sortable?" do
		it "returns true if there's a sortable column" do
			make_sortable(@opts)
			@obj = Datatable::Request.new(@opts)
			@obj.sortable?.should be_true
		end
	end

	describe "#construct_conditions" do
		it "constructs a WHEREable string" do
			@opts["sSearch_0"] = "foo"
			@opts["bSearchable_0"] = "true"
			@opts["bRegex_0"] = "false"
		
			@obj = Datatable::Request.new(@opts)
			@obj.construct_conditions.should == "problem LIKE 'foo'"
		end
		it "constructs a WHEREable string" do
			@opts["sSearch_0"] = "foo"
			@opts["bSearchable_0"] = "true"
			@opts["bRegex_0"] = "true"
		
			@obj = Datatable::Request.new(@opts)
			@obj.construct_conditions.should == "problem ~ 'foo'"
		end
	end

	describe "#construct_order" do
		it "creates an SQL fragment for the ORDER clause" do
			make_sortable(@opts)
			@obj = Datatable::Request.new(@opts)
			@obj.construct_order.should == "#{@columns[@opts['iSortCol_0']]} #{@opts['sSortDir_0'].upcase}"
		end
		it "uses overrides when provided" do
			@opts["sSort_1"] = "meet DIR, round DIR"
			@opts["iSortingCols"] = 2
			@opts["iSortCols"] = 
			@opts["iSortCol_0"] = 1
			@opts["sSortDir_0"] = "asc"
			@opts["iSortCol_1"] = 2
			@opts["sSortDir_1"] = "asc"
			@obj = Datatable::Request.new(@opts)
			@obj.construct_order.should =~ /year ASC,\s*meet ASC,\s*round ASC/
		end
	end

	describe "#construct_select" do
		it "should be return a comma-delimited list of columns if there are no overrides" do
			@obj = Datatable::Request.new(@opts)
			@obj.construct_select.should == @columns.join(',')
		end
		it "should look for sSelect_x and fix up the select list" do
			@opts["sColumns"] = "problem,year,meet_and_round,number"
			@opts['sSelect_2'] = 'meet,round'
			@obj = Datatable::Request.new(@opts)
			@obj.construct_select.should == "problem,year,meet,round,number"
		end
	end

	describe "#args_for_find" do
		before :each do
			@obj = Datatable::Request.new(@opts)
			@args = @obj.args_for_find
		end

		describe ":limit" do
			it "should be an integer" do
				@args[:limit].should be_kind_of Integer
			end
		end
	
		describe ":offset" do
			it "should be an integer" do
				@args[:offset].should be_kind_of Integer
			end
		end
	
		describe ":conditions" do
			it "shouldn't exist if not searchable" do
				@args[:conditions].should be_nil
			end

			it "should exist if searchable" do
				make_searchable(@opts)
				@obj = Datatable::Request.new(@opts)
				@obj.searchable?.should be_true
				@args = @obj.args_for_find
				@args[:conditions].should be_kind_of String
			end
		end
	
		describe ":construct_order" do
			it "shouldn't exist if not sortable" do
				@obj = Datatable::Request.new(@opts)
				@args = @obj.args_for_find
				@args[:order].should be_nil
			end
		
			it "should contain a string if sortable" do
				make_sortable(@opts)
				@obj = Datatable::Request.new(@opts)
				@args = @obj.args_for_find
				@args[:order].should be_kind_of String
			end
		end
	end
			
end
