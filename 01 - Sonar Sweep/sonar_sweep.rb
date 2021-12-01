file = File.open("input")
input = file.readlines.map(&:to_i)

## Part One ##

previous = -1
count = -1
input.each do |nbr|
	if nbr > previous
		count += 1
	end
	previous = nbr
end
puts count

## Part Two ##

previous = Array.new(3) {-1}
current = Array.new(previous)
count = -3
input.each do |nbr|
	current.rotate!(-1)
	current[0] = nbr
	if current[0] + current[1] + current[2] > previous[0] + previous[1] + previous[2]
		count += 1
	end
	previous = current.clone
end
puts count
