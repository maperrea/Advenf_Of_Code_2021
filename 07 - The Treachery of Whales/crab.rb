input = File.read("input").split(',').map(&:to_i)

## Part One ##

shortest = -1
(0...input.max).each do |i|
	distance = 0
	input.each { |pos| distance += (pos - i).abs }
	if distance < shortest || shortest == -1
		shortest = distance
	end
end

puts shortest

## Part Two ##

shortest = -1
(0...input.max).each do |i|
	distance = 0
	input.each { |pos| distance += (((pos - i).abs * ((pos - i).abs + 1)) / 2) }
	if distance < shortest || shortest == -1
		shortest = distance
	end
end

puts shortest
