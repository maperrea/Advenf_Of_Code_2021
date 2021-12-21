require "scanf"
input = File.readlines("input").map(&:chomp)

class Beacon

	@@count = 0

	attr_reader :x, :y, :z
	attr_reader :scanner
	attr_reader :distances
	attr_reader :same_as

	def initialize(coordinates, scanner)
		@x = coordinates[0]
		@y = coordinates[1]
		@z = coordinates[2]
		@scanner = scanner
		@distances = Hash.new
		@same_as = Array.new
	end

	def add_distance(b)
		if b == self
			return
		end
		@distances[b] = (b.x - @x) ** 2 + (b.y - @y) ** 2 + (b.z - @z) ** 2
	end

	def cmp(b)
		i = 0
		distances.each do |ba, da|
			b.distances.each do |bb, db|
				if da == db
					i += 1
				end
			end
		end
		if i >= 11
#			@@count += 1
#			puts @@count
			same_as << b
		end
	end
end

class Scanner

	@@amount = 0

	attr_reader :beacons
	attr_reader :id

	def initialize()
		@id = @@amount
		@@amount += 1
		@beacons = []
	end

	def add_beacon(b)
		@beacons << b
	end

end

current_scanner = Scanner.new
@scanners = [current_scanner]
@beacon_count = 0
input.each do |line|
	if line.empty?
		current_scanner = Scanner.new
		@scanners << current_scanner
		next
	end
	if line.chars[1] == '-'
		next
	end
	current_scanner.add_beacon(Beacon.new(line.scanf("%d,%d,%d"), current_scanner))
	@beacon_count += 1
end

@scanners.each do |scanner|
	scanner.beacons.each do |a|
		scanner.beacons.each do |b|
			a.add_distance(b)
		end
	end
end

@scanners.each do |sa|
	@scanners.each do |sb|
		if sa == sb
			next
		end
		sa.beacons.each do |ba|
			sb.beacons.each do |bb|
				ba.cmp(bb)
			end
		end
	end
end
		
puts "beacons = %d" % [@beacon_count]

doubles = 0.0
@scanners.each do |s|
	s.beacons.each do |b|
		if !b.same_as.empty?
			doubles += b.same_as.size / 2.0
		end
	end
end

puts "doubles = %f" % [doubles]
