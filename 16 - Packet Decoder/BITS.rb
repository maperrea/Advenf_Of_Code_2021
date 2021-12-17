require "scanf"

# Number of bits for each identifier
Version = 3
Packet_type = 3
Length_type = 1
Length = [15, 11]
# length_type = 0 : number of bits for sub packets
# length_type = 1 : number of sub packets
Sum = 0
Product = 1
Minimum = 2
Maximum = 3
Literal = 4
Greater_than = 5
Less_than = 6
Equal_to = 7
$version_sum = 0

class Packet
	attr_accessor :version
	attr_accessor :packet_type
	attr_accessor :bits
	attr_accessor :length_type
	attr_accessor :length
	attr_accessor :value

	def initialize(type = 0, bits = 0)
		@packet_type = type
		@bits = bits
	end

	def read_meta(input, position)
		puts position
		@version = read_bits(input, position, Version)
		position >>= Version
		$version_sum += @version
		@packet_type = read_bits(input, position, Packet_type)
		position >>= Packet_type
		@bits = 6
		return self
	end

	def read_value(input, position)
		@value = 0
		last = false
		while !last
			if input & position == 0
				last = true
			end
			position >>= 1
			@value <<= 4
			@value += read_bits(input, position, 4)
			position >>= 4
			@bits += 5
		end
		return position
	end

	def read_length_operator(input, position)
		@length_type = read_bits(input, position, Length_type)
		position >>= Length_type
		@length = read_bits(input, position, Length[@length_type])
		position >>= Length[@length_type]
		@bits += (Length_type + Length[@length_type])
		return position
	end

	def set_value(value)
		@value = value
		return self
	end

	def do_op(a, b)
#		puts "[%d, %d] : %d" % [a.value, b.value, @packet_type]
		case @packet_type
		when Sum
			return Packet.new(@packet_type, @bits).set_value(a.value + b.value)
		when Product
			return Packet.new(@packet_type, @bits).set_value(a.value * b.value)
		when Minimum
			return Packet.new(@packet_type, @bits).set_value(a.value > b.value ? b.value : a.value)
		when Maximum
			return Packet.new(@packet_type, @bits).set_value(a.value > b.value ? a.value : b.value)
		when Literal
			puts "Error: do_op on literal"
			exit
		when Greater_than
			return Packet.new(@packet_type, @bits).set_value(a.value > b.value ? 1 : 0)
		when Less_than
			return Packet.new(@packet_type, @bits).set_value(a.value < b.value ? 1 : 0)
		when Equal_to
			return Packet.new(@packet_type, @bits).set_value(a.value == b.value ? 1 : 0)
		end
	end

end

def print_packet(packet, depth)
	if depth >= 1
		padding = "\t" * depth
#		puts ("\t" * (depth - 1)) + "{"
	else
		padding = ""
	end
	case packet.packet_type
	when Literal
#		puts padding + "Version: " + packet.version.to_s
#		puts padding + "Type: Literal"
		puts padding + packet.value.to_s
	else
#		puts padding + "Version: " + packet.version.to_s
#		print padding + "Type: "
		case packet.packet_type
		when Sum
			puts padding + "+" + " -> " + packet.value.to_s
		when Product
			puts padding + "*" + " -> " + packet.value.to_s
		when Minimum
			puts padding + "<?" + " -> " + packet.value.to_s
		when Maximum
			puts padding + ">?" + " -> " + packet.value.to_s
		when Greater_than
			puts padding + ">" + " -> " + packet.value.to_s
		when Less_than
			puts padding + "<" + " -> " + packet.value.to_s
		when Equal_to
			puts padding + "==" + " -> " + packet.value.to_s
		end
#		puts padding + "Length type: " + packet.length_type.to_s
#		puts padding + "Length: " + packet.length.to_s
	end
	if depth >= 1
#		puts ("\t" * (depth - 1)) + "}"
	end
end

def read_bits(input, position, length)
	value = 0
	(0...length).each do |_|
		value <<= 1
		if input & position != 0
			value += 1
		end
		position >>= 1
	end
	return value
end

def literal(input, position, packet)
	position = packet.read_value(input, position)
	return packet
end

def operator(input, position, packet, depth)
	position = packet.read_length_operator(input, position)
	sub_packets = Array.new
	case packet.length_type
	when 0
		packet.bits += packet.length
		finish = position >> packet.length
		while position > finish
			new_packet = packet(input, position, depth + 1)
			position >>= new_packet.bits
			sub_packets << new_packet
		end
	when 1
		(0...packet.length).each do |_|
			new_packet = packet(input, position, depth + 1)
			position >>= new_packet.bits
			packet.bits += new_packet.bits
			sub_packets << new_packet
		end
	end
	if sub_packets.empty?
		return Packet.new(packet.packet_type, packet.bits).set_value(0)
	end
	result = sub_packets[0]
	result.packet_type = packet.packet_type
	(1...sub_packets.size).each do |i|
		result = packet.do_op(result, sub_packets[i])
	end
	return result
end

def packet(input, position, depth)
	if !position
		return 0
	end
	packet = Packet.new.read_meta(input, position)
	position >>= Version + Packet_type
	case packet.packet_type
	when Literal
		packet = literal(input, position, packet)
	else
		puts ("\t" * depth) + packet.length_type.to_s
		puts ("\t" * depth) + "{"
		packet = operator(input, position, packet, depth)
		puts ("\t" * depth) + "}"
	end
	print_packet(packet, depth)
	return packet
end

#(12...19).each do |i|
#	input = File.readlines("examples")[i].chomp
	input = File.read("input").chomp
	@bits = input.size * 4
	input = input.scanf("%x")[0]
	
	result = packet(input, 1 << (@bits - 1), 0)
#	puts $version_sum
#	puts "\n="
#	puts result.value
	puts "________________"
#end
