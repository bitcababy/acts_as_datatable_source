Factory.define :test_model do |p|
	p.foo				{ Factory.next :foo}
	p.bar				{ Factory.next :bar }
end

Factory.sequence :foo do |n|
	"foo_#{n}"
end

Factory.sequence :bar do |n|
	n
end