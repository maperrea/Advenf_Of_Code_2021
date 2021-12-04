file = File.open("input")
input = file.readlines.map(&:chomp)

class Board

	def initialize
		@arr = Array.new(5) { Array.new(5) }
		@rows = 0
		@has_won = false  #for part two
	end

	def addRow(row)
		if @rows >= 5
			puts "Error: too much rows"
			exit
		end
		@arr[@rows] = row.split(' ').map(&:to_i)
		@rows += 1
	end

	def addNumber(nb)
		for i in (0..4)
			for j in (0..4)
				if @arr[i][j] == nb
					@arr[i][j] = -1
					return isBingo(i, j)
				end
			end
		end
		return false
	end
	
	def isBingo(x, y)
		if !@has_won && (check_row(x) || check_column(y))
			@has_won = true
			return true
		end
		return false
	end

	def check_row(x)
		for j in (0..4)
			if @arr[x][j] != -1
				return false
			end
		end
		return true
	end

	def check_column(y)
		for i in (0..4)
			if @arr[i][y] != -1
				return false
			end
		end
		return true
	end

	def sum
		sum = 0
		@arr.each do |row|
			row.each do |elem|
				if elem != -1
					sum += elem
				end
			end
		end
		return sum
	end

	def print
		puts @arr
	end
end

boards = Array.new
input.delete_if { |str| str.empty? }
numbers = input.shift.split(',').map(&:to_i)
input.each_with_index do |row, idx|
	if idx % 5 == 0
		boards << Board.new
	end
	boards[boards.size - 1].addRow(row)
end

first = true

numbers.each do |nb|
	boards.each do |board|
		if board.addNumber(nb)
			@last = nb * board.sum
			if first
				puts nb * board.sum
				first = false
			end
		end
	end
end

puts @last
