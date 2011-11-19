Factory.define :test_model do |p|
	p.problem		{ Factory.next :problem }
	p.year			{ Factory.next :year }
	p.meet			{ Factory.next :meet }
	p.round			{ Factory.next :round }
	p.number		{ Factory.next :number }
end

Factory.sequence :problem do |n|
	"Problem #{n}"
end

Factory.sequence :year do |n|
	[2001,2002,2003][n%3]
end

Factory.sequence :meet do |n|
	(n%6)+1
end

Factory.sequence :round do |n|
	(n%4)+1
end

Factory.sequence :number do |n|
	(n%3)+1
end

