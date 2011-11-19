class TestModel < ActiveRecord::Base
	acts_as_datatable_source
	
	attr_reader :meet_round

	def meet_round
		"#{meet}/#{round}"
	end
	
	def self.ds_select_for(key)
		case key
		when 'meet_round'
			return 'meet,round'
		else key
		end
	end
	
	def self.ds_order_for(key)
		case key
		when 'meet_round'
			'meet,round'
		else
			key
		end
	end

end
