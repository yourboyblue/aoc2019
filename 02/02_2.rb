require './computer.rb'

program = File.read('input.txt').split(",").map(&:to_i)

(0..99).each do |v1|
  (0..99).each do |v2|
    test_program = program.dup
    test_program[1] = v1
    test_program[2] = v2
    Computer.run(test_program)
    if test_program[0] == 19690720
      puts (v1 * 100) + v2
      break
    end
  end
end

