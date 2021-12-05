require "scanf"
input = File.read("input")

class Point
	
	attr_accessor :x
	attr_accessor :y

	def initialize(x, y)
		@x = x
		@y = y
	end
end

def range(x, y)
	if x > y
		return x.downto(y)
	else
		return x.upto(y)
	end
end


class Line

	attr_reader :start
	attr_reader :end
	
	def initialize(_start, _end)
		@start = _start
		@end = _end
	end

	def each
		if @start.x == @end.x
			range(@start.y, @end.y).each { |i| yield Point.new(@start.x, i) }
		elsif @start.y == @end.y
			range(@start.x, @end.x).each { |i| yield Point.new(i, @start.y) }
		else
			x = range(@start.x, @end.x)
			y = range(@start.y, @end.y)
			i = x.size
			while i > 0
				yield Point.new(x.next, y.next)
				i -= 1
			end
		end
	end
end

class Board

	def initialize(x, y)
		@w = x
		@h = y
		@board = Array.new(x) { Array.new(y) { 0 } }
	end

	def add_line(line)
		line.each do |point|
			@board[point.x][point.y] += 1
		end
	end

	def show
		for y in (0...@h)
			for x in (0...@w)
				if @board[x][y] == 0
					print "."
				else
					print @board[x][y]
				end
			end
			print "\n"
		end
	end

	def crossings
		i = 0
		for y in (0...@h)
			for x in (0...@w)
				if @board[x][y] > 1
					i += 1
				end
			end
		end
		return i
	end
		
end

lines = Array.new

input.scanf("%d,%d -> %d,%d\n") do |x1, y1, x2, y2|
	lines << Line.new(Point.new(x1, y1), Point.new(x2, y2))
end

board = Board.new(1000, 1000)

lines.each do |line|
	board.add_line(line)
end

puts board.crossings
