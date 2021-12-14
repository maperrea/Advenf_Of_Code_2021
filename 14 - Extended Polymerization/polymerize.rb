require "scanf"
input = File.readlines("input").map(&:chomp)

@start = input.shift.chars
input.shift

@polymer = Hash.new {0}
(1...@start.size).each do |i|
	@polymer[@start[i - 1] + @start[i]] += 1
end

@pairs = Hash.new
input.each do |line|
	data = line.scanf("%s -> %s")
	@pairs[data[0]] = data[1]
end

(0...40).each do |i|
	new_polymer = Hash.new {0}
	@polymer.each do |key, value|
		new_polymer[key.chars[0] + @pairs[key]] += value
		new_polymer[@pairs[key] + key.chars[1]] += value
	end
	@polymer = new_polymer
end


@count = Hash.new {0}
@polymer.each do |key, value|
	@count[key.chars[0]] += value
end
@count[@start.last] += 1

puts @count.values.max - @count.values.min
