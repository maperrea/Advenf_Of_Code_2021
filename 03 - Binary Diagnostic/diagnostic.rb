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
	if (one >= zero)
		return (1 << i)
	else
		return 0
	end
end

oxygen = input.clone
co2 = input.clone

11.downto(0) do |i|
	most_common = get_most_common(oxygen, i)
	if oxygen.size > 1
		oxygen.delete_if { |j| j & (1 << i) == ~most_common & (1 << i) }
	end
	most_common = get_most_common(co2, i)
	if co2.size > 1
		co2.delete_if { |j| j & (1 << i) == most_common & (1 << i) }
	end
end

puts oxygen[0] * co2[0]
