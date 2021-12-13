@input = File.readlines("input").map { |line| line.chomp.chars.map(&:to_i) }

## Part One ##

#W = @input.size
#H = @input[0].size
#@map = @input

## Part Two ##

IW = @input.size
IH = @input[0].size

W = IW * 5
H = IH * 5

@map = Array.new(W) { Array.new(H) }
(0...W).each do |x|
	(0...H).each do |y|
		@map[x][y] = @input[x % IW][y % IH] + (x / IW) + (y / IH)
		if (@map[x][y] > 9)
			@map[x][y] = (@map[x][y] % 10) + 1
		end
	end
end

class Node
	attr_reader :x
	attr_reader :y
	attr_reader :cost
	attr_reader :dist

	def initialize(x, y, cost = 0)
		@x = x
		@y = y
		@cost = cost
		@dist = cost + (W - x - 1) + (H - x - 1)
	end

	def set_cost(cost)
		@cost = cost
		@dist = cost + (W - x - 1) + (H - x - 1)
	end	
end

@closed_list = Array.new(W) { Array.new(H) { -1 } }
@open_list = Array.new

@open_list << Node.new(0, 0, 0)

def find_node(nodes, node)
	nodes.each do |n|
		if n.x == node.x && n.y == node.y
			return n
		end
	end
	return nil
end

def print_explored(closed, open)
	(0...W).each do |x|
		(0...H).each do |y|
			n = Node.new(x, y)
			if (closed[x][y] != -1)
				print " # "
			elsif (found = find_node(open, n))
				print "%3d" % [found.dist.to_s]
			else
				print " . "
			end
		end
		puts
	end
end

#step = 0
while !@open_list.empty? do
#	step += 1
#	puts step
	n = @open_list.shift
	if n.x == W - 1 && n.y == H - 1
		@final = n
		break
	end
	[n.x - 1, n.x + 1].each do |x|
		if x != n.x && x >= 0 && x < W
			new = Node.new(x, n.y, n.cost + @map[x][n.y])
			if @closed_list[x][n.y] != -1
				if @closed_list[x][n.y] > new.cost
					@closed_list[x][n.y] = new.cost
				end
			elsif (found = find_node(@open_list, new))
				if found.cost > new.cost
					found.set_cost(new.cost)
				end
			else
				if (index = @open_list.index { |e| e.cost >= new.cost })
					@open_list.insert(index, new)
				else
					@open_list << new
				end
			end
		end
	end
	[n.y - 1, n.y + 1].each do |y|
		if y != n.y && y >= 0 && y < H
			new = Node.new(n.x, y, n.cost + @map[n.x][y])
			if @closed_list[n.x][y] != -1
				if @closed_list[n.x][y] > new.cost
					@closed_list[n.x][y] = new.cost
				end
			elsif (found = find_node(@open_list, new))
				if found.cost > new.cost
					found.set_cost(new.cost)
				end
			else
				if (index = @open_list.index { |e| e.cost >= new.cost })
					@open_list.insert(index, new)
				else
					@open_list << new
				end
			end
		end
	end
	@closed_list[n.x][n.y] = n.cost
#	puts "[%d, %d] : %d" % [n.y, n.x, n.cost]
#	print_explored(@closed_list, @open_list)
#	puts "__________"
end

#puts step

if !@final
	puts "Error: no end found"
else
	puts @final.cost
end
