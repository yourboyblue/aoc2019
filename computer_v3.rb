require 'pry'
class IntComputer
  def self.run(program, read: [], write: [], thread_id: 0)
    computer = new(program, read: read, write: write, thread_id: thread_id)
    current_op_code = 0
    until current_op_code == 99 do
      state = computer.cycle!
      current_op_code = state[:op_code]
      puts state
    end
    puts state[:write].join(',')
  end

  def initialize(program, read: [], write: [], thread_id: 0)
    @sizes = [0, 4, 4, 2, 2, 3, 3, 4, 4, 2]
    @program = program
    @ptr = 0
    @relative_base = 0
    @read = read
    @write = write
    @thread_id = thread_id
    @op_code = 0
    @instruction = ''
  end

  def cycle!
    instruction = @program[@ptr]
    @instruction = instruction
    @op_code = instruction % 100

    # Early return if 99 so we don't load values out of program array bounds
    return state if @op_code == 99
    print "#{modes(instruction)} | "
    values = values(instruction, @ptr, @relative_base, @program)
    case @op_code
    when 1 # sum
      @program[values[2]] = values[0] + values[1]
      print "INSERT #{values[0] + values[1]} at #{values[2]}".ljust(32)
      @ptr += 4
    when 2 # product
      @program[values[2]] = values[0] * values[1]
      print "INSERT #{values[0] * values[1]} at #{values[2]}".ljust(32)
      @ptr += 4
    when 3
      passed_val = @read.pop
      return state unless passed_val # waiting on input, noop for cycle

      index = @program[@ptr + 1]
      index = index + @relative_base if modes(instruction).first.to_i == 2
      @program[index] = passed_val
      print "INSERT #{passed_val} at #{index}".ljust(32)
      @ptr += 2
    when 4
      binding.pry
      @write << values.first
      print "WRITE #{values.first}".ljust(32)
      @ptr += 2
    when 5 # jump if true
      if values[0].zero?
        print "NOOP jump if true, false".ljust(32)
        @ptr += 3
      else
        print "JUMP to #{values[1]}".ljust(32)
        @ptr = values[1]
      end
    when 6 # jump if false
      if values[0].zero?
        @ptr = values[1]
        print "JUMP to #{values[1]}".ljust(32)
      else
        print "NOOP jump if false, true".ljust(32)
        @ptr += 3
      end
    when 7 # write less than
      if values[0] < values[1]
        @program[values[2]] = 1
        print "INSERT 1 at #{values[2]}".ljust(32)
      else
        @program[values[2]] = 0
        print "INSERT 0 at #{values[2]}".ljust(32)
      end
      @ptr += 4
    when 8 # write equal
      if values[0] == values[1]
        @program[values[2]] = 1
        print "INSERT 1 at #{values[2]}".ljust(32)
      else
        @program[values[2]] = 0
        print "INSERT 0 at #{values[2]}".ljust(32)
      end
      @ptr += 4
    when 9
      print "RELATIVE BASE from #{@relative_base} to #{@relative_base + values[0]}".ljust(32)
      @relative_base += values[0]
      @ptr += 2
    else
      raise "Invalid op_code #{@op_code}"
    end
    state
  end

  def state
    { instruction: @instruction.to_s.rjust(6), op_code: @op_code, read: @read, write: @write, ptr: @ptr, rel_base: @relative_base, thread_id: @thread_id }
  end

  private

  def values(instruction, ptr, relative_base, program)
    modes(instruction).map.with_index(1) do |mode, i|
      case mode.to_i
      when 0
        index = program[ptr + i]
        value_at(index)
      when 1
        index = ptr + i
        value_at(index)
      when 2
        index = relative_base + program[ptr + i]
        value_at(index)
      end
    end
  end

  def value_at(index)
    over_bound = (index + 1) - @program.length
    grow_memory(over_bound) if over_bound.positive?
    @program[index]
  end

  def grow_memory(amount)
    # puts "Increasing memory by #{amount}"
    @program = @program + Array.new(amount, 0)
  end

  def modes(instruction)
    digits = instruction.to_s.chars
    digits.pop(2) # discard op_code digits
    modes = [] << digits.pop << digits.pop
    # Final mode is always immediate/relative, for the store location
    write_mode = digits.pop == '2' ? 2 : 1
    modes << write_mode
  end
end


