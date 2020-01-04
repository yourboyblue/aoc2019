require './computer.rb'

program = File.read('input.txt').split(",").map(&:to_i)
program[1] = 12
program[2] = 2
Computer.run(program)
puts program[0]
