require "scanf"
input = File.readlines("input").map(&:chomp)

# Get first line as array and remove the empty line
@start = input.shift.chars
input.shift

# Transform the array into the initail hash { pair, amount }
@polymer = Hash.new {0}
(1...@start.size).each do |i|
	@polymer[@start[i - 1] + @start[i]] += 1
end

# Make the hash with each transformation
@pairs = Hash.new
input.each do |line|
	data = line.scanf("%s -> %s")
	@pairs[data[0]] = data[1]
end

# Calculate for each existing pair the amount of created pairs
(0...40).each do |i|
	new_polymer = Hash.new {0}
	@polymer.each do |key, value|
		new_polymer[key.chars[0] + @pairs[key]] += value
		new_polymer[@pairs[key] + key.chars[1]] += value
	end
	@polymer = new_polymer
end

# Count the occurences of each character.
# Only the first is taken into account simce they are all doubled,
# apart from the very first and very last
@count = Hash.new {0}
@polymer.each do |key, value|
	@count[key.chars[0]] += value
end
@count[@start.last] += 1

puts @count.values.max - @count.values.min
