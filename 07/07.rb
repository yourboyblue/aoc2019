require '../computer_v3.rb'

software = File.read('input.txt').split(',').map(&:to_i)
signals = []
version = :v2

# v1
if version == :v1
  phase_settings = [0,1,2,3,4].permutation
  phase_settings.each do |ps|
    buffer = [0]

    5.times do |i|
      buffer.push(ps.pop)
      program = software.dup
      amplifier = IntComputer.new(program, read: buffer, write: buffer)

      op_code = nil
      while op_code != 99 do
        state = amplifier.cycle!
        op_code = state[:op_code]
      end

    end

    signals << buffer.pop
  end

  puts signals.max
end

# v2
if version == :v2
  phase_settings = [5,6,7,8,9].permutation
  phase_settings.each do |ps|
    buffers = ps.map { |ps| [ps] } # seed phase settings in buffers
    buffers[0].unshift(0) # hardcoded input for amplifier #1
    amplifiers = {}

    buffers.each_with_index do |read_buffer, index|
      program = software.dup
      write_buffer = if index + 1 == buffers.length
                         buffers.first
                       else
                         buffers[index + 1]
                       end

      amplifier = IntComputer.new(program, read: read_buffer, write: write_buffer, thread_id: index)
      amplifiers[amplifier] = 1
    end

    while !amplifiers.values.all? { |op_code| op_code == 99 } do
      amplifiers.each_pair do |amplifier, prev_op_code|
        next if prev_op_code == 99
        amplifier_state = amplifier.cycle!
        amplifiers[amplifier] = amplifier_state[:op_code]
      end
    end

    signals << buffers.map(&:pop).compact.max
  end

  puts signals.max
end

# Written before realizing ruby has Array#permutation
# def permutation(values)
#   permutations = [[]]
#   values.length.times do |i|
#     remaining_count = values.length - i
#     # Dup each permutation N times, where N is number of loops remaining
#     permutations = permutations.flat_map { |p| remaining_count.times.with_object([]) { |_i, arr| arr << p.dup } }
#     remaining = []

#     permutations.each do |permutation|
#       remaining = values - permutation if remaining.empty?
#       append_val = remaining.pop
#       permutation << append_val
#     end
#   end
#   permutations
# end
