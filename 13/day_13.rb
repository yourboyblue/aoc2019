require '../computer_v4.rb'

program = File.read('input.txt').split(',').map(&:to_i)
computer = IntComputer.new(program, input = [], output = [])
halt = false
until halt do
  halt = output.last == 99
  computer.cycle
end

screen_buffer = {}
until output.empty? do
  x, y, entity = output.shift(3)
  screen_buffer[[x, y]] = entity
end
puts screen_buffer.values.count { |v| v == 2 }
