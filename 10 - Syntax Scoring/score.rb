input = File.readlines("input").map(&:chomp)

## Part One ##

@score = 0

input.each do |line|
	instructions = Array.new
	line.chars.each do |c|
		case c
		when ")"
			match = instructions.pop
			if match != "("
				@score += 3
				break
			end
		when "]"
			match = instructions.pop
			if match != "["
				@score += 57
				break
			end
		when "}"
			match = instructions.pop
			if match != "{"
				@score += 1197
				break
			end
		when ">"
			match = instructions.pop
			if match != "<"
				@score += 25137
				break
			end
		else
			instructions.push(c)
		end
	end
end

puts @score

## Part two ##

@scores = []

input.each do |line|
	score = 0
	instructions = Array.new
	correct = true
	line.chars.each do |c|
		case c
		when ")"
			match = instructions.pop
			if match != "("
				correct = false
				break
			end
		when "]"
			match = instructions.pop
			if match != "["
				correct = false
				break
			end
		when "}"
			match = instructions.pop
			if match != "{"
				correct = false
				break
			end
		when ">"
			match = instructions.pop
			if match != "<"
				correct = false
				break
			end
		else
			instructions.push(c)
		end
	end
	if (!correct)
		next
	end
	while (c = instructions.pop)
		score *= 5
		case c
		when "("
			score += 1
		when "["
			score += 2
		when "{"
			score += 3
		when "<"
			score += 4
		end
	end
	@scores.push(score)
end

puts @scores.sort[@scores.size / 2]
