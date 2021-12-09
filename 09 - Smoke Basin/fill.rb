@input = File.readlines("input").map { |str| str.chomp.chars.map(&:to_i) }

def is_lowest(x, y)
	if(x - 1 >= 0 && @input[x - 1][y] <= @input[x][y])
		return false
	elsif(x + 1 < @input.size && @input[x + 1][y] <= @input[x][y])
		return false
	elsif(y - 1 >= 0 && @input[x][y - 1] <= @input[x][y])
		return false
	elsif(y + 1 < @input[x].size && @input[x][y + 1] <= @input[x][y])
		return false
	end
	return true
end

def flood_fill(x, y)
	if x < 0 || y < 0 || x >= @input.size || y >= @input[x].size || @input[x][y] == 9
		return 0
	end
	@input[x][y] = 9
	return 1 + flood_fill(x - 1, y) + flood_fill(x + 1, y) + flood_fill(x, y - 1) + flood_fill(x, y + 1)
end
	
basins = Array.new

(0...@input.size).each do |x|
	(0...@input[x].size).each do |y|
		if is_lowest(x, y)
			size = flood_fill(x, y)
			basins << size
		end
	end
end

basins.sort!.reverse!
puts basins[0] * basins[1] * basins[2]
