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
			zero += 1 end
	end
#	puts ">>>"
#	puts one
#	puts zero
#	puts "<<<"
	if (one >= zero)
		return (1 << i)
	else
		return 0
	end
end

=begin this is shit?? but why
oxygen = input.clone
co2 = input.clone

11.downto(0) do |i|
	gamma = get_most_common(oxygen, i)
	j = 0
	puts gamma.to_s(2)
	for j in (0...oxygen.size)
		if ((oxygen[j] & (1 << i)) == (~gamma) & (1 << i)) && oxygen.size > 1 
			oxygen.delete_at(j)
		j += 1
		end
	end
	puts oxygen.size
	j = 0
	for j in (0...co2.size)
		if ((co2[j] & (1 << i)) == gamma & (1 << i)) && co2.size > 1
			co2.delete_at(j)
		else
			j += 1
		end
	end
end

puts "___"
puts oxygen.size
puts co2.size
puts oxygen[0]
puts co2[0]
puts oxygen[0] * co2[0]
*/
=end

## Other way ##

oxygen = input.clone
co2 = input.clone

11.downto(0) do |i|
	most_common = get_most_common(oxygen, i)
	if oxygen.size > 1
		oxygen.delete_if { |j| j & (1 << i) == ~most_common & (1 << i) }
	end
#	puts oxygen.size
	most_common = get_most_common(co2, i)
	if co2.size > 1
		co2.delete_if { |j| j & (1 << i) == most_common & (1 << i) }
	end
#	puts co2.size
#	puts "______"
end

#puts oxygen[0]
#puts co2[0]
puts oxygen[0] * co2[0]
