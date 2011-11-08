require 'spec_helper'
require 'active_record'

class Foo < ActiveRecord::Base
	acts_as_datatable_source
end

describe ActsAsDatatableSource::Base do
	it "should have installed :acts_as_datatable_source" do
		Foo.should respond_to :acts_as_datatable_source
	end
	it "should have installed :select_for_datatable" do
		Foo.should respond_to :select_for_datatable
	end
	it "should have installed :count_for_datatable" do
		Foo.should respond_to :count_for_datatable
	end
	it "should have installed :construct_for_json" do
		Foo.should respond_to :construct_for_json
	end
end
