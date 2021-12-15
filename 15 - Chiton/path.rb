@input = File.readlines("input").map { |line| line.chomp.chars.map(&:to_i) }

## Part One ##

W = @input.size
H = @input[0].size
@map = @input

## Part Two ##

#IW = @input.size
#IH = @input[0].size
#
#W = IW * 5
#H = IH * 5
#
#@map = Array.new(W) { Array.new(H) }
#(0...W).each do |x|
#	(0...H).each do |y|
#		@map[x][y] = @input[x % IW][y % IH] + (x / IW) + (y / IH)
#		if (@map[x][y] > 9)
#			@map[x][y] = (@map[x][y] % 10) + 1
#		end
#	end
#end

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

@closed_list = Array.new
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
			if (found = find_node(closed, n))
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

step = 0
while !@open_list.empty? do
	step += 1
	@open_list.sort_by! { |node| node.dist }
	n = @open_list.shift
	if n.x == W - 1 && n.y == H - 1
		@final = n
		break
	end
	(n.x - 1 .. n.x + 1).each do |x|
		if x != n.x && x >= 0 && x < W
			new = Node.new(x, n.y, n.cost + @map[x][n.y])
			if (found = find_node(@closed_list, new)) || (found = find_node(@open_list, new))
				if found.cost > new.cost
					found.set_cost(new.cost)
				end
			else
				@open_list << new
			end
		end
	end
	(n.y - 1 .. n.y + 1).each do |y|
		if y != n.y && y >= 0 && y < H
			new = Node.new(n.x, y, n.cost + @map[n.x][y])
			if (found = find_node(@closed_list, new)) || (found = find_node(@open_list, new))
				if found.cost > new.cost
					found.set_cost(new.cost)
				end
			else
				@open_list << new
			end
		end
	end
	@closed_list << n
#	puts "[%d, %d] : %d" % [n.y, n.x, n.cost]
#	print_explored(@closed_list, @open_list)
#	puts "__________"
end

puts step
puts @final.cost

def print_path()
	@path = [@final]
	previous = @final
	while previous.x != 0 || previous.y != 0
		min = nil
		(previous.x - 1 .. previous.x + 1).each do |x|
			if x != previous.x && x >= 0 && x < H
				if (found = find_node(@closed_list, Node.new(x, previous.y, 0)))
					if !min || found.cost < min.cost
						min = found
					end
				end
			end
		end
		(previous.y - 1 .. previous.y + 1).each do |y|
			if y != previous.y && y >= 0 && y < W
				if (found = find_node(@closed_list, Node.new(previous.x, y, 0)))
					if !min || found.cost < min.cost
						min = found
					end
				end
			end
		end
		previous = min
		@path.unshift(previous)
	end
	
	@path.each do |node|
		puts "[%d, %d] : %d" % [node.y, node.x, node.cost]
	end
end
