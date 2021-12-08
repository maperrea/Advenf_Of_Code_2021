input = File.readlines("input").map(&:chomp)

## Part One ##

@count = 0
input.each do |line|
	nbrs = line.split(' ')
	(11..14).each do |i|
		if nbrs[i].size == 2 || nbrs[i].size == 3 || nbrs[i].size == 4 || nbrs[i].size == 7
			@count += 1
		end
	end
end

puts @count

## Part two ##

@count = 0

input.each do |line|
	n = Array.new(10)
	@signal = line.split(' ')[0..10].map { |str| str.split('') }
	@output = line.split(' ')[11..14].map { |str| str.split('') }
	@signal.each do |nbr|
		case nbr.length
		when 2
			n[1] = nbr
		when 3
			n[7] = nbr
		when 4
			n[4] = nbr
		when 7
			n[8] = nbr
		end
	end
	@signal.each do |nbr|
		if nbr.length == 6
			if n[7].all? { |c| nbr.include? c } && n[4].all? { |c| nbr.include? c }
				n[9] = nbr
			elsif n[7].all? { |c| nbr.include? c }
				n[0] = nbr
			else
				n[6] = nbr
			end
		end
	end
	@signal.each do |nbr|
		if nbr.length == 5
			if n[7].all? { |c| nbr.include? c }
				n[3] = nbr
			elsif nbr.all? { |c| n[6].include? c }
				n[5] = nbr
			else
				n[2] = nbr
			end
		end
	end
	n.map! { |nbr| nbr.sort }
	@output.each_with_index do |out, idx|
		n.each_with_index do |nbr, i|
			if nbr == out.sort
				@count += i * (1000 / (10 ** idx))
			end
		end
	end
end

puts @count
