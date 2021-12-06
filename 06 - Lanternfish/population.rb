input = File.read("input").split(',').map(&:to_i)

fishes = Array.new(9) { 0 }
input.each do |i|
	fishes[i] += 1
end


(0..255).each do |i|
	new = fishes[0]
	(0..7).each do |i|
		fishes[i] = fishes[i + 1]
	end
	fishes[8] = new
	fishes[6] += new
end

sum = 0
fishes.each { |fish| sum += fish }
puts sum
