class Instruction
  def self.build(instruction, addr, stack)
    code = instruction.to_s.chars[(-2..-1)]
    get_const("I#{code}").new(addr, stack)
  end
end

class Param
  def init(mode, val, stack)
    @mode = mode
    @val = val
    @stack
  end

  def read
    case @mode
    when :position
      @stack[val]
    when :immediate
      val
    when :stdin
      get
    end
  end
end

class I
  MODES = {
    0      => :position,
    1      => :immediate,
    nil    => :immediate,
    :stdin => :stdin
  }

  def init(code, addr, stack)
    @code = code
    @addr = addr
    @stack = stack
    @instruction = stack[addr].to_i
  end

  attr_reader :addr, :stack, :instruction, :code

  def modes
    instruction[(0...-3)].chars.map(&:to_i).reverse
  end

  def params
    modes.each_with_index do |m, i|
      val = stack[addr + i]
      Param.new(m, val, stack)
    end
  end

  def params_count
    params.length
  end
end

class I01 < I
  def initialize(addr, stack)
    super(1, addr, stack)
  end

  def write
    store_addr = params.last.read
    stack[store_addr] = params[0].read + params[1].read
  end
end

class I02
  def initialize(addr, stack)
    super(2, addr, stack)
  end

  def write
    store_addr = params.last.read
    stack[store_addr] = params[0].read * params[1].read
  end
end

class I03
  def initialize(addr, stack)
    super(3, addr, stack)
  end

  def params
    [Param.new(:stdin), Params.new(:immediate, stack[addr + 1])]
  end

  def write
    store_addr = params.last.read
    stack[store_addr] = params[0].read
  end
end

class I04
  def initialize(addr, stack)
    super(4, addr, stack)
  end

  def params
    [Params.new(:immediate, stack[addr + 1])]
  end

  def write
    puts params[0].read
  end
end

class I99
  def initialize(addr, stack)
    super(99, addr, stack)
  end

  def params
    []
  end

  def write
    false
  end
end

class Computer
  def initialize(program)
    @program = program
    @instruction_ptr = 0
  end

  attr_reader :program, :instruction_ptr

  def instruction_int
    program[instruction_ptr]
  end

  def advance(count)
    @instruction_ptr += count
  end

  def self.run(program)
    computer = new(program)
    puts computer.methods
    loop do
      instruction = Instruction.build(computer.instruction_int, instruction_ptr, program)
      write_val = instruction.write
      break unless write_val
      computer.advance(instruction.params_count)
    end
  end
end
