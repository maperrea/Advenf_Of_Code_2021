require "scanf"
input = File.read("input").scanf("target area: x=%d..%d, y=%d..%d")

xmin = input[0]
xmax = input[1]
ymin = input[2]
ymax = input[3]

def sum(x)
	return (x * (x + 1)) / 2
end

xstart_min = 0
while sum(xstart_min) < xmin
	xstart_min += 1
end
xstart_max = xmax


ystart_min = ymin
ystart_max = -ymin - 1

puts sum(ystart_max)

@count = 0

(xstart_min..xstart_max).each do |vx|
	xstart = vx
	steps = 0
	x = 0
	found = []
	vx.downto(0) do |vx|
		x += vx
		steps += 1
		if x >= xmin && x <= xmax
			(ystart_min..ystart_max).each do |vy|
				ystart = vy
				y = 0
				ysteps = 0
				if vx != 0
					(0...steps).each do |_|
						y += vy
						vy -= 1
						ysteps += 1
					end
				else
					while y + vy >= ymin
						ysteps += 1
						y += vy
						vy -= 1
					end
				end
				if y >= ymin && y <= ymax && !found.include?(ystart) && ysteps >= steps
					@count += 1
					found << ystart
				end
			end
		end
	end
end

puts @count
