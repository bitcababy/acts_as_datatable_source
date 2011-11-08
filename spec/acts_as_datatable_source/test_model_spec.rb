require 'spec_helper'

describe TestModel do
	include DatatableHelperMethods
	
	before :each do
		@opts = create_opts(@columns = %W{foo bar})
		clean_database!
	end

	context "Make sure methods have been added" do
		it "responds to :acts_as_datatable_source" do
			TestModel.should respond_to(:acts_as_datatable_source)
		end

		it "responds to :select_for_datatable" do
			TestModel.should respond_to(:select_for_datatable)
		end

		it "responds to :construct_for_json" do
			TestModel.should respond_to(:construct_for_json)
		end
	end

	describe "#count_for_datatable" do
		it "should return the number of records" do
			5.times {Factory :test_model}
			TestModel.count_for_datatable(@opts).should == 5
		end
	end
	
	describe "#select_for_datatable" do
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

end
