class TestModel < ActiveRecord::Base
	acts_as_datatable_source
	
	def bar_quux
		"#{self.read_attribute('bar').to_s}/#{self.read_attribute('quux').to_s}"
	end
	
end

