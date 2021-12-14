require "scanf"
input = File.readlines("input").map { |line| line.chomp.gsub("fold along ", "").gsub("=", " ") }


points = Array.new
folds = Array.new

i = 0
while !input[i].empty?
	points << input[i].scanf("%d,%d")
	i += 1
end

i += 1

while i < input.size
	folds << input[i].scanf("%s %d")
	i += 1
end

folds.each do |fold|
	case fold[0]
	when "x"
		points.each do |point|
			if point[0] > fold[1]
				point[0] = 2 * fold[1] - point[0]
			end
		end
	when "y"
		points.each do |point|
			if point[1] > fold[1]
				point[1] = 2 * fold[1] - point[1]
			end
		end
	end
end

W = points.max { |a, b| a[0] <=> b[0] } [0]
H = points.max { |a, b| a[1] <=> b[1] } [1]

puts W
puts H

(0..H).each do |y|
	(0..W).each do |x|
		if points.include? [x, y]
			print "\033[47m \033[0m"
		else
			print " "
		end
	end
	puts
end
