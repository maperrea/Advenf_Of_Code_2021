require "scanf"
input = File.read("input").gsub("-", " ")

class Cave
	
	attr_reader :name
	attr_reader :connected
	attr_reader :small

	def initialize(name)
		@name = name
		if name.chars[0] >= 'a' && name.chars[0] <= 'z'
			@small = true
		else
			@small = false
		end
		@connected = Array.new
	end

	def add_connection(connection)
		@connected << connection
	end

	def can_go(path)
		if @small && path.include?(self)
			return false
		else
			return true
		end
	end
end

@caves = []
@paths = 0

input.scanf("%s %s\n") do |a, b|
	if !(c_a = @caves.detect { |c| c.name == a })
		c_a = Cave.new(a)
		@caves << c_a
	end
	if !(c_b = @caves.detect { |c| c.name == b })
		c_b = Cave.new(b)
		@caves << c_b
	end
	c_a.add_connection(c_b)
	c_b.add_connection(c_a)
end

def traverse(path, cave, twice)
	if cave.name == "end"
		@paths += 1
#		path.each { |c| print c.name + " " }
#		puts
		return
	end
	cave.connected.each do |c|
		if c.can_go(path)
			traverse(path + [c], c, twice)
		elsif !twice && c.name != "start"
			traverse(path + [c], c, true)
		end
	end
end

start = @caves.detect { |c| c.name == "start" }
traverse([start], start, false)
puts @paths
