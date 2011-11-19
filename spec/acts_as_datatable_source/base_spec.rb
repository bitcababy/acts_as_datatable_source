require 'spec_helper'
require 'active_record'

describe ActsAsDatatableSource::Base do
	include DatatableHelperMethods

	before :each do
		@opts = create_opts %W(problem year meet_round number)
		TestModel.delete_all
	end

	describe "::construct_select" do
		it "should collect a list of fields to be selected" do
			dr = Datatable::Request.new(@opts)
			TestModel.construct_select(dr).should == "problem,year,meet,round,number"
		end
	end

	describe "::construct_order" do
		it "should collect a list of fields to be selected" do
			@opts['iSortingCols'] = "1"
			@opts['iSortCol_0'] = "2"
			@opts['sSortDir_0'] = 'asc'
			dr = Datatable::Request.new(@opts)
			TestModel.construct_order(dr).should =~ /meet\s+ASC\s*,\s*round\s+ASC/
		end
	end

	describe "::acts_as_datatable_source?" do
		it "should return true" do
			TestModel.acts_as_datatable_source?.should be_true
		end
	end

	describe "::count_for_datatable (no conditions)" do
		it "should return the number of records" do
			5.times {Factory :test_model}
			TestModel.count_for_datatable(@opts).should == 5
		end
	end

	describe "::select_for_datatable" do
		it "should return the 'iDisplayLength' number of records if there are enough" do
			20.times {Factory :test_model}
			@opts["iDisplayLength"] = "10"
			models = TestModel.select_for_datatable(@opts)
			models.should_not be_nil
			models.count.should == 10
		end

		it "should return the number of records if there aren't enough" do
			5.times {Factory :test_model}
			@opts["iDisplayLength"] = "10"
			models = TestModel.select_for_datatable(@opts)
			models.should_not be_nil
			models.count.should == 5
		end
	end

	describe "#fetch_attribute" do
		it "returns a (possibly massaged) value for the attribute" do
			model = Factory(:test_model, :year => 2008)
			model.fetch_attribute("year").should == 2008
		end
	end

	describe "::construct_for_json" do
		before :each do
			@models = []
			5.times {|i| @models << (Factory :test_model)}
		end

		context "no sorting" do
			before :each do
				@opts['iSortingCols'] = 0
				@res = TestModel.construct_for_json(@opts)
			end
			
			it "returns a hash" do
				@res.should be_kind_of Hash
			end

			it "should contain 'sEcho', 'iTotalRecords', 'iTotalDisplayRecords', 'sColumns', and 'aaData' " do
				%W(sEcho iTotalRecords iTotalDisplayRecords sColumns aaData).each do |field|
					@res[field].should_not be_nil
				end
			end

			it "contains 'sEcho', which should match the value from @opts" do
				@res['sEcho'].should == @opts['sEcho']
			end

			it "contains 'iTotalRecords', which should match the total number of records" do
				@res['iTotalRecords'].should == 5
			end
			it "contains 'iTotalDisplayRecords', which should match the number of records displayed" do
				@res['iTotalDisplayRecords'].should == 5
			end
			it "contains 'sColumns', which should match sName" do
				@res['sColumns'].should be_kind_of String
				@res['sColumns'].split(',') == @columns
			end

			describe "aaData" do
				before :each do
					@aaData = @res['aaData']
					@sColumns = @res['sColumns'].split(",")
				end
				it "should contain an array for each record" do
					@aaData.should be_kind_of Array
					@aaData.count.should == @res['iTotalDisplayRecords']
					@sColumns.count.should == 4
					# We can test this way because of no sorting
					@res['iTotalDisplayRecords'].times do |i|
						model = @models[i]
						data = @sColumns.collect do |col| 
							model.fetch_attribute(col)
						end
						@aaData[i].should == data
					end
				end
			end

		end # no sorting
		
		def make_sortable
			@opts['iSortingCols'] = "1"
			@opts['iSortCol_0'] = "2"
			@opts['sSortDir_0'] = 'asc'
		end
		
		describe "#sortable?" do
			it "returns true if there's a sortable column" do
				make_sortable
				dr = Datatable::Request.new(@opts)
				TestModel.sortable?(dr).should be_true
			end
		end
		
		context "searchable-related methods" do
			describe "#searchable?" do
	
				it "should return false if there's nothing to search for" do
					dr = Datatable::Request.new(@opts)
					TestModel.searchable?(dr).should be_false
				end
		
				it "should return true if any bSearchables is true and the search string isn't empty" do
					@opts['bSearchable_2'] = "true"
					@opts['sSearch_2'] = "foo"
					@opts['bRegex_2'] = "false"
					dr = Datatable::Request.new(@opts)
					TestModel.searchable?(dr).should be_true
				end
		
				it "should return true if sSearch isn't empty" do
					@opts["sSearch"] = "foo"
					dr = Datatable::Request.new(@opts)
					TestModel.searchable?(dr).should be_true
				end
			end
		end
	end
	
	describe "args_for_find" do
		before :each do
			@opts = create_opts %W(problem year meet_round number)
		end
		
		it "returns a hash of the arguments acceptable to find" do
			dr = Datatable::Request.new(@opts)
			hash = TestModel.args_for_find(dr)
			hash.should be_kind_of Hash
		end

		it "includes :limit and :offset" do
			dr = Datatable::Request.new(@opts)
			hash = TestModel.args_for_find(dr)
			hash[:limit].should be_kind_of Integer
			hash[:offset].should be_kind_of Integer
		end

		it "returns a hash of the arguments for calling find with (no sort)" do
			dr = Datatable::Request.new(@opts)
			hash = TestModel.args_for_find(dr)
			hash.should be_kind_of Hash
			hash[:select].should_not be_nil
			hash[:order].should be_nil
		end

		it "returns a hash of the arguments for calling find with sort" do
			@opts['iSortingCols'] = "1"
			@opts['iSortCol_0'] = "2"
			@opts['sSortDir_0'] = 'asc'
			dr = Datatable::Request.new(@opts)
			hash = TestModel.args_for_find(dr)
			hash[:order].should_not be_nil
		end

	end

end
