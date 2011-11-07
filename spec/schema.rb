ActiveRecord::Schema.define :version => 0 do
	create_table :datatable_models, :force => true do |t|
		t.string :foo
		t.int :bar
	end
end