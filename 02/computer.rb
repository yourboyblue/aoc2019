class Computer
  def initialize(program)
    @program = program
    @instruction = 0
  end

  def self.run(program)
    computer = new(program)
    loop do
      next_chunk = computer.read
      op_code = computer.execute(*next_chunk)
      break if op_code == 99
      computer.step
    end
  end

  def instruction(instruction_ptr)
    @program[@instruction]
  end

  def params(op_code)
    case op_code
    when
  end

  def step(count)
    @instruction += count
  end

  def execute(code, *values, store)
    case code
    when 99
      return code
    when 1
      v1, v2 = @program[pos1], @program[pos2]
      res = v1 + v2
      @program[store] = res
    when 2
      v1, v2 = @program[pos1], @program[pos2]
      res = v1 * v2
      @program[store] = res
    else
      raise 'Unknown opcode'
    end
    code # return
  end

  def get_val(mode, )
end

class Instruction
  def self.from_code(code)
    case code
    when '01'
      new('01', 3)
    when '02'
      new('01', 3)
    when '03'
      new('03', 1)
    when '04'
      new('04', 1)
    when '99'
      new('99', 0)
    else
      raise 'Unknown opcode'
    end
  end

  attr_reader :code, :param_count

  def init(code, param_count)
    @code = code
    @param_count = param_count
  end
end

class Param
  def init(mode, i, stack)
    @mode = mode
    @i = i
    @stack
  end

  def val
    case @mode
    when :position
      @stack[i]
    when :immediate
      i
    when :stdin
      get
    end
  end
end

class I
  MODES = {
   0 => :position,
   1 => :immediate,
   nil => :immediate
  }
end

class I01 < I
  def initialize(addr, stack)
    @code = '01'
    @addr = addr
    @instuction = stack[addr]
  end

  def modes
    @instruction[(0...-3)].chars.reverse
  end

  def params
    modes.each_with_index do |m, i|
      val = stack[addr + i]
      Param.new(m, val, stack)
    end
  end
end

class I02
end

class I03
end

class I04
end

class I05
end
