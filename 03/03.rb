require 'set'

wire1, wire2 = File.read('input.txt').split("\n")

def trace(wire)
  coords = Set.new
  x, y = 0, 0
  runs = wire.split(',')
  runs.each do |run|
    dir = run.chr
    len = run[(1..-1)].to_i
    len.times do |i|
      case dir
      when 'U'
        coords << [x, y += 1]
      when 'D'
        coords << [x, y -= 1]
      when 'L'
        coords << [x -= 1, y]
      when 'R'
        coords << [x += 1, y]
      end
    end
  end
  coords
end

def manhattan(c1, c2)
  (c1[0] - c2[0]).abs + (c1[1] - c2[1]).abs
end

wire1_coords = trace(wire1)
wire2_coords = trace(wire2)
intersects = (wire1_coords & wire2_coords) - [0,0]

puts intersects.map { |c| manhattan([0,0], c) }.min
