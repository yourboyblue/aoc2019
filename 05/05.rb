require '../computer_v3.rb'

program = File.read('input.txt').split(',').map(&:to_i)
IntComputer.run(program)
