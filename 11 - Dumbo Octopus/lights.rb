@input = File.readlines("input").map { |line| line.chomp.chars.map(&:to_i) }

W = @input.size
H = @input[0].size

@control = Array.new(W) { Array.new(H) }

def add_around(x, y)
	(x - 1..x + 1).each do |_x|
		(y - 1..y + 1).each do |_y|
			if (_x != x || _y != y) && _x >= 0 && _x < W && _y >= 0 && _y < H && !@control[_x][_y]
				@input[_x][_y] += 1
			end
		end
	end
end

def synchronized?
	@control.each do |column|
		column.each do |val|
			if !val
				return false
			end
		end
	end
	return true
end

@step = 0
@blinks = 0

while !synchronized? do
	@step += 1
	done = false
	@input.map! { |column| column.map! { |val| val + 1} }
	@control.map! { |column| column.map! { false } }
	while !done
		done = true
		(0...W).each do |x|
			(0...H).each do |y|
				if @input[x][y] > 9
					@input[x][y] = 0
					@control[x][y] = true
					@blinks += 1
					done = false
					add_around(x, y)
				end
			end
		end
	end
#	@input.each do |column|
#		column.each do |val|
#			print "%d" % [val]
#		end
#		puts
#	end
#	puts
#	puts "____"
end

puts @step
puts @blinks
