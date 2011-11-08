ActiveRecord::Schema.define :version => 0 do
	create_table :test_models, :force => true do |t|
		t.string 	:foo
		t.integer	:bar
	end
end
