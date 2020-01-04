require '../computer_v4.rb'

version = :v2
program = File.read('input.txt').split(',').map(&:to_i) if version == :v1
program = File.read('input2.txt').split(',').map(&:to_i) if version == :v2
input = [1] if version == :v1
input = [2] if version == :v2

IntComputer.run(program, input: input)
