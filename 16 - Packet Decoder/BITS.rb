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

	def initialize(input, position)
		@version = read_bits(input, position, Version)
		position >>= Version
		$version_sum += @version
		@packet_type = read_bits(input, position, Packet_type)
		position >>= Packet_type
		@bits = 6
		@length_type = 0
		@length = 0
		@value = 0
	end

	def set_value(input, position)
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

	def set_length_operator(input, position)
		@length_type = read_bits(input, position, Length_type)
		position >>= Length_type
		@length = read_bits(input, position, Length[@length_type])
		position >>= Length[@length_type]
		@bits += (Length_type + Length[@length_type])
		return position
	end

end

def print_packet(packet, depth)
	if depth >= 1
		padding = "\t" * depth
		puts ("\t" * (depth - 1)) + "{"
	else
		padding = ""
	end
	case packet.packet_type
	when Literal
		puts padding + "Version: " + packet.version.to_s
		puts padding + "Type: Literal"
		puts padding + "Value: " + packet.value.to_s
	else
		puts padding + "Version: " + packet.version.to_s
		puts padding + "Type: Operator"
		puts padding + "Length type: " + packet.length_type.to_s
		puts padding + "Length: " + packet.length.to_s
	end
	if depth >= 1
		puts ("\t" * (depth - 1)) + "}"
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
	position = packet.set_value(input, position)
	return packet
end

def operator(input, position, packet, depth)
	position = packet.set_length_operator(input, position)
	case packet.length_type
	when 0
		packet.bits += packet.length
		finish = position >> packet.length
		while position > finish
			new_packet = packet(input, position, depth + 1)
			position >>= new_packet.bits
		end
	when 1
		(0...packet.length).each do |_|
			new_packet = packet(input, position, depth + 1)
			position >>= new_packet.bits
			packet.bits += new_packet.bits
		end
	end
	return packet
end

def packet(input, position, depth)
	if !position
		return 0
	end
	packet = Packet.new(input, position)
	position >>= Version + Packet_type
	case packet.packet_type
	when Sum
	when Product
	when Minimum
	when Maximun
	when Literal
		packet = literal(input, position, packet)
	when Greater_than
	when Less_than
	when Equal_to
	else
		packet = operator(input, position, packet, depth)
	end
	print_packet(packet, depth)
	return packet
end

input = File.readlines("input")[0].chomp
@bits = input.size * 4
input = input.scanf("%x")[0]

packet(input, 1 << (@bits - 1), 0)
puts $version_sum
