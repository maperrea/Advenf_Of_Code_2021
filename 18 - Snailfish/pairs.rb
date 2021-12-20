input = File.readlines("input").map { |line| line.chomp.chars }

@numbers = Array.new(input.size) { Hash.new }

def parse(line, i, hash)
	if line[i] == "["
		hash[:x] = Hash.new
		i = parse(line, i + 1, hash[:x])
	else
		hash[:x] = line[i].to_i
		i += 2
	end

	if line[i] == "["
		hash[:y] = Hash.new
		i = parse(line, i + 1, hash[:y])
	else
		hash[:y] = line[i].to_i
		i += 2
	end

	return i + 1
end

input.each_with_index do |line, i|
	parse(line, 1, @numbers[i])
end

#@numbers.each do |number|
#	p number
#end

def add_right(number, value)
	if number[:y].is_a? Integer
		number[:y] += value
	else
		add_right(number[:y], value)
	end
end

def add_left(number, value)
	if number[:x].is_a? Integer
		number[:x] += value
	else
		add_left(number[:x], value)
	end
end

def reduce(number, depth = 0)
	if number.is_a? Integer
		return {status: 0}
	elsif depth == 4
		return {status: 2, x: number[:x], y: number[:y]}
	end

	ret = reduce(number[:x], depth + 1)
	if ret[:status] > 0
		if ret[:status] == 2
			number[:x] = 0
			ret[:status] = 1
		end
		if number[:y].is_a? Integer
			number[:y] += ret[:y]
		else
			add_left(number[:y], ret[:y])
		end
		ret[:y] = 0
		return ret
	end

	ret = reduce(number[:y], depth + 1)
	if ret[:status] > 0
		if ret[:status] == 2
			number[:y] = 0
			ret[:status] = 1
		end
		if number[:x].is_a? Integer
			number[:x] += ret[:x]
		else
			add_right(number[:x], ret[:x])
		end
		ret[:x] = 0
		return ret
	end

	return {status: 0}
	
end

def split(number)
	if number.is_a? Integer
		return 0
	elsif number[:x].is_a?(Integer) && number[:x] >= 10
		number[:x] = {x: number[:x] / 2, y: (number[:x] + 1) / 2}
		return 1
	elsif split(number[:x]) == 1
		return 1
	elsif number[:y].is_a?(Integer) && number[:y] >= 10
		number[:y] = {x: number[:y] / 2, y: (number[:y] + 1) / 2}
		return 1
	elsif split(number[:y]) == 1
		return 1
	else
		return 0
	end
end

def add(a, b)
	output = {x: Marshal.load(Marshal.dump(a)), y: Marshal.load(Marshal.dump(b))}
	spl = 1
	while spl == 1
		red = reduce(output)
		while red[:status] == 1
			red = reduce(output)
		end
		spl = split(output)
	end
	return output
end

def magnitude(number)
	if number.is_a? Integer
		return number
	else
		return (3 * magnitude(number[:x])) + (2 * magnitude(number[:y]))
	end
end

def show(number, depth = 0)
	print "["
	if number[:x].is_a? Hash
		show(number[:x], depth + 1)
	else
		print number[:x]
	end
	print ","
	if number[:y].is_a? Hash
		show(number[:y], depth + 1)
	else
		print number[:y]
	end
	print "]"
	if depth == 0
		puts
	end
end

## Part One ##
#
output = add(@numbers[0], @numbers[1])
(2...@numbers.size).each do |i|
	output = add(output, @numbers[i])
end
#show output
puts magnitude(output)

## Part two ##

max = 0
(0...@numbers.size).each do |i|
	(0...@numbers.size).each do |j|
		if i != j && (mag = magnitude(add(@numbers[i], @numbers[j]))) > max
			max = mag
		end
	end
end
puts max
