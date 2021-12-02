file = File.open("input")
input = file.readlines.map { |line| line.split(" ", 2) }

## Part One ##

position = 0
height = 0

input.each do |line|
	case line[0]
		when "forward"
			position += line[1].to_i
		when "up"
			height -= line[1].to_i
		when "down"
			height += line[1].to_i
		else
			puts "wrong input"
	end
end
puts position * height

## Part Two ##

position = 0
height = 0
aim = 0

input.each do |line|
	case line[0]
		when "forward"
			position += line[1].to_i
			height += line[1].to_i * aim
		when "up"
			aim -= line[1].to_i
		when "down"
			aim += line[1].to_i
		else
			puts "wrong input"
	end
end
puts position * height
