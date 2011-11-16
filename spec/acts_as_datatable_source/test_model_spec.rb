require 'spec_helper'

describe TestModel do
	include DatatableHelperMethods
	
	before :each do
		clean_database!
		@opts = create_opts(@columns = %W{foo bar quux})
	end

	describe "::acts_as_datatable_source?" do
		it "should return true" do
			TestModel.acts_as_datatable_source?.should be_true
		end
	end

	describe "::count_for_datatable" do
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
			model = Factory(:test_model, :foo => 'b', :bar => 2, :quux => 4)
			model.fetch_attribute("foo").should == 'b'
		end
	end

	describe "::construct_for_json" do
		before :each do
			@models = []
			@models << Factory(:test_model, :foo => 'b', :bar => 2, :quux => 4)
			@models << Factory(:test_model, :foo => 'a', :bar => 3, :quux => 42)
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
				@res['iTotalRecords'].should == 2
			end
			it "contains 'iTotalDisplayRecords', which should match the number of records displayed" do
				@res['iTotalDisplayRecords'].should == 2
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
					@sColumns.count.should == 3
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
		end

		context "faux attributes" do
			before :each do
				@opts = create_opts(@columns = %W{foo bar_quux})
				@opts['sSelect_1'] = 'bar, quux'
				@opts['sSort_1'] = 'bar DIR, quux DIR'
				@res = TestModel.construct_for_json(@opts)
				@aaData = @res['aaData']
				@sColumns = @res['sColumns'].split(",")
			end

			it "should contain an array for each record" do
				@aaData.count.should == @res['iTotalDisplayRecords']
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

	end

end
