wire1, wire2 = File.read('input.txt').split("\n")

def trace(wire)
  coords = {}
  steps = 0
  x, y = 0, 0
  runs = wire.split(',')
  runs.each do |run|
    dir = run.chr
    len = run[(1..-1)].to_i
    len.times do |i|
      steps += 1
      case dir
      when 'U'
        coords[[x, y += 1]] = steps
      when 'D'
        coords[[x, y -= 1]] = steps
      when 'L'
        coords[[x -= 1, y]] = steps
      when 'R'
        coords[[x += 1, y]] = steps
      end
    end
  end
  coords.tap { |cs| cs.delete([0,0])}
end

wire1_coords = trace(wire1)
wire2_coords = trace(wire2)
intersect_steps = []

wire1_coords.keys.each do |c|
  next unless wire2_coords[c]
  intersect_steps << wire1_coords[c] + wire2_coords[c]
end

puts intersect_steps.min
