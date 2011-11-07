require 'spec_helper'

describe Datatable::Request do
	before :each do
		@columns = %W(problem year meet_and_round number)
		@opts = {
			"sEcho"=>"1",
			"iColumns"=>"4",
			"sColumns"=>"problem,year,meet_and_round,number",
			"iDisplayStart"=>"0",
			"iDisplayLength"=>"10",
			"mDataProp_0"=>"0",
			"mDataProp_1"=>"1",
			"mDataProp_2"=>"2",
			"mDataProp_3"=>"3",
			"sSearch"=>"",
			"bRegex"=>"false",
			"sSearch_0"=>"",
			"bRegex_0"=>"false",
			"bSearchable_0"=>"true", 
			"sSearch_1"=>"", 
			"bRegex_1"=>"false", 
			"bSearchable_1"=>"true", 
			"sSearch_2"=>"", 
			"bRegex_2"=>"false", 
			"bSearchable_2"=>"true", 
			"sSearch_3"=>"", 
			"bRegex_3"=>"false", 
			"bSearchable_3"=>"true", 
			"iSortingCols"=>"1", 
			"iSortCol_0"=>"2", 
			"sSortDir_0"=>"asc", 
			"bSortable_0"=>"false", 
			"bSortable_1"=>"true", 
			"bSortable_2"=>"true", 
			"bSortable_3"=>"true", 
			"_"=>"1320590438382"}
		
				
	end

	# attr_accessor :sEcho, :iDisplayStart, :iDisplayLength, :iColumns, :aColumns, :mDataProps
	# attr_accessor :aSortables, :iSortingCols, :aSortCols, :aSortDirs
	# attr_accessor :sSearch, :bRegex, :aSearchables, :aSearches, :aRegexes

	context "initialization" do
		describe "#initialize_basics" do
			before :each do
				@obj = Datatable::Request.new(@opts)
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
				@obj.iColumns.should == 4
			end
	
			it "sets aColumns" do
				@obj.aColumns.should == @columns
			end

			it "sets sSearch" do
				@obj.sSearch.should_not be_nil
			end
		
			it "sets iSortingCols" do
				@obj.iSortingCols.should == 1
			end
		
			it "should be sortable" do
				@obj.sortable?.should be_true
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
				@opts["bSortable_1"] = "false"
				@opts["bSortable_2"] = "true"
				@opts["bSortable_3"] = "false"
			
				@obj = Datatable::Request.new(@opts)
			end
		
			it "creates aSortables" do
				@obj.aSortables.should == [true, false, true, false]
			end
	
			it "creates aSortCols" do
				@obj.aSortCols.should == [0, 2]
			end

			it "creates aSortDirs" do
				@obj.aSortDirs.should == ["ASC", "DESC"]
			end		
		end #initialize_sorts
		
		describe "#initialize_searches" do
			before :each do
				@opts["sSearch"] = ""
				@opts["bSearchable_0"] = "true"
				@opts["bSearchable_1"] = "false"
				@opts["bSearchable_2"] = "false"
				@opts["bSearchable_3"] = "false"
				@opts["sSearch_0"] = "foo"
				@opts["sSearch_1"] = ""
				@opts["sSearch_2"] = ""
				@opts["sSearch_3"] = ""
				@opts["bRegex_0"] = "false"
				@opts["bRegex_1"] = "false"
				@opts["bRegex_2"] = "false"
				@opts["bRegex_3"] = "false"

				@obj = Datatable::Request.new(@opts)
			end
		
			it "creates aSearchables" do
				@obj.aSearchables.should == [true, false, false, false]
			end
		
			it "creates aSearches" do
				@obj.aSearches.should == ["foo", "", "", ""]
			end
		
			it "creates aRegexes" do
				@obj.aRegexes.should == [false, false, false, false]
			end
		
		end #initialize_searches
	end
	
	describe "#searchable?" do
		it "should return true if any aSearchables is true and the search string isn't empty" do
			@opts["sSearch"] = ""
			@opts["bSearchable_0"] = "true"
			@opts["bSearchable_1"] = "false"
			@opts["bSearchable_2"] = "false"
			@opts["bSearchable_3"] = "false"
			@opts["sSearch_0"] = "foo"
			@opts["sSearch_1"] = ""
			@opts["sSearch_2"] = ""
			@opts["sSearch_3"] = ""
			@opts["bRegex_0"] = "false"
			@opts["bRegex_1"] = "false"
			@opts["bRegex_2"] = "false"
			@opts["bRegex_3"] = "false"

			@obj = Datatable::Request.new(@opts)
			
			@obj.searchable?.should be_true
		end
	end
	
	describe "#conditions" do
		it "constructs a WHEREable string" do
			@opts["sSearch_2"] = "foo"
			
			@obj = Datatable::Request.new(@opts)
			@obj.conditions.should == "meet_and_round LIKE 'foo'"
		end
	end
	
	describe "#order" do
		it "creates an SQL fragment for the ORDER clause" do
			@opts["iSortingCols"] = "1"
			@opts["iSortCol_0"] = 2
			@opts["sSortDir_0"] = "asc"
			@obj = Datatable::Request.new(@opts)
			@obj.order.should == "meet_and_round ASC"
		end
	end
	
	# def args_for_find
	# 	args = {select: self.select, limit: @iDisplayLength, offset: @iDisplayStart}
	# 	args[:conditions] = self.conditions if self.searchable?
	# 	args[:order] = self.order if self.sortable?
	# 	return args
	# end
	
	describe "#args_for_find" do
		before :each do
			@obj = Datatable::Request.new(@opts)
			@args = @obj.args_for_find
		end

		describe ":select" do
			it "should be a comma-delimited list of columns" do
				@args[:select].should be_kind_of String
			end
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
				@opts["sSearch_2"] = "foo"
				@obj = Datatable::Request.new(@opts)
				@obj.searchable?.should be_true
				@args = @obj.args_for_find
				@args[:conditions].should be_kind_of String
			end
		end
		
		describe ":order" do
			it "shouldn't exist if not sortable" do
				@opts["iSortingCols"] = "0"
				@obj = Datatable::Request.new(@opts)
				@obj.sortable?.should be_false
				@args = @obj.args_for_find
				@args[:order].should be_nil
			end
			
			it "should contain a string if sortable" do
				@obj.sortable?.should be_true
				@args = @obj.args_for_find
				@args[:order].should be_kind_of String
			end
				
		end
				
		
		
	end
			
end
