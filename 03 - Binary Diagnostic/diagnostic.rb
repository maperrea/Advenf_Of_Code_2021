file = File.open("input")
input = file.readlines.map { |line| line.to_i(2) }

## Part One ##

gamma = 0
epsilon = 0

for i in (0..11)
	one = 0
	input.each do |nb|
		if ((nb & (1 << i)) > 0)
	 		one += 1
		end
	end
	puts one
	if (one > 500)
		gamma |= (1 << i)
	else
		epsilon |= (1 << i)
	end
end

puts gamma * epsilon

## Part Two ##

def get_most_common(input, i)
	one = 0
	zero = 0
	input.each do |nb|
		if ((nb & (1 << i)) > 0)
	 		one += 1
		else
			zero += 1
		end
	end
	puts one
	if (one > zero)
		return (1 << i)
	else
		return 0
	end
end

oxygen = input.clone
co2 = input.clone

11.downto(0) do |i|
	gamma = get_most_common(oxygen, i)
	j = 0
	oxygen.each do |ox|
		if (ox & (1 << i) == gamma & (1 << i)) && oxygen.size > 1 
			oxygen.delete_at(j)
		else
			j += 1
		end
	end
	puts j
	puts oxygen.size
	j = 0
	co2.each do |co|
		if (co & (1 << i) == (~gamma) & (1 << i)) && co2.size > 1
			co2.delete_at(j)
		else
			j += 1
		end
	end
end

puts oxygen[0]
puts co2[0]
puts oxygen[0] * co2[0]

## Other way ##

oxygen = input.clone
co2 = input.clone
puts oxygen[0]
oxygen.delete_at(0)
puts co2[0]
puts "-----------"

11.downto(0) do |i|
	gamma = get_most_common(oxygen, i)
	puts gamma
	if oxygen.size > 1
		oxygen.delete_if { |j| @last_ox = j ; j & (1 << i) == gamma & (1 << i) }
	end
	gamma = get_most_common(co2, i)
	puts gamma
	if co2.size > 1
		co2.delete_if { |j| @last_co2 = j ; j & (1 << i) == ~gamma & (1 << i) }
	end
end

if oxygen.size == 1
	@last_ox = oxygen[0]
end
if co2.size == 1
	@last_co2 = co2[0]
end

puts @last_ox
puts @last_co2
puts @last_ox * @last_co2
