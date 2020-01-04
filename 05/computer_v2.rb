require 'pry'

class Instruction
  def self.build(instruction, addr, stack)
    code = instruction.to_s.rjust(2, '0').chars[(-2..-1)].join
    Object.const_get("I#{code}").new(addr, stack)
  end
end

class Param
  MODES = {
    0 => :position,
    1 => :immediate
  }

  def initialize(mode, val, stack)
    @mode = mode_to_sym(mode)
    @val = val
    @stack = stack
  end

  def read
    case @mode
    when :position
      @stack[@val]
    when :immediate
      @val
    when :stdin
      print 'Enter your input: '
      send(:gets).strip.to_i
    end
  end

  def mode_to_sym(m)
    return m if m.is_a?(Symbol)
    MODES[m]
  end
end

class I
  def initialize(code, instruction, addr, stack)
    @code = code
    @addr = addr
    @stack = stack
    @instruction = instruction
  end

  attr_reader :addr, :stack, :instruction, :code

  def modes
    instruction[0..-3].chars.map(&:to_i).reverse
  end

  def params
    modes.map.with_index do |mode, i|
      val = stack[addr + i + 1]
      Param.new(mode, val, stack)
    end
  end

  def params_count
    params.length
  end
end

class I01 < I
  def initialize(addr, stack)
    instruction = stack[addr].to_s.rjust(4, '0')
    instruction = instruction.rjust(5, '1') # write param
    super(1, instruction, addr, stack)
  end

  def write
    store_addr = params.last.read
    res = params[0].read + params[1].read
    stack[store_addr] = res
    msg = "(#{instruction}) writing #{res} (#{params[0].read} + #{params[1].read}) to addr: #{store_addr}"
    move_instruction = [:step, params_count]
    { msg: msg, move_instruction: move_instruction }
  end
end

class I02 < I
  def initialize(addr, stack)
    instruction = stack[addr].to_s.rjust(4, '0')
    instruction = instruction.rjust(5, '1') # write param
    super(2, instruction, addr, stack)
  end

  def write
    store_addr = params.last.read
    res = params[0].read * params[1].read
    stack[store_addr] = res
    msg = "(#{instruction}) writing #{res} (#{params[0].read} * #{params[1].read}) to addr: #{store_addr}"
    move_instruction = [:step, params_count]
    { msg: msg, move_instruction: move_instruction }
  end
end

class I03 < I
  def initialize(addr, stack)
    instruction = stack[addr].to_s.rjust(2, '0')
    instruction = instruction.rjust(3, '1') # write param
    super(3, instruction, addr, stack)
  end

  def params
    [Param.new(modes.first, stack[addr + 1], stack)]
  end

  def write
    store_addr = params.last.read
    stack[store_addr] = res = Param.new(:stdin, nil, stack).read
    msg ="writing #{res} to addr: #{store_addr}"
    move_instruction = [:step, params_count]
    { msg: msg, move_instruction: move_instruction }
  end
end

class I04 < I
  def initialize(addr, stack)
    instruction = stack[addr].to_s.rjust(3, '0')
    super(4, instruction, addr, stack)
  end

  def params
    [Param.new(modes.first, stack[addr + 1], stack)]
  end

  def write
    puts res = params[0].read
    msg = "(#{instruction}) writing #{res} to stdout"
    move_instruction = [:step, params_count]
    { msg: msg, move_instruction: move_instruction }
  end
end

class I05 < I
  def initialize(addr, stack)
    instruction = stack[addr].to_s.rjust(4, '0')
    super(5, instruction, addr, stack)
  end

  def write
    move_instruction = if params.first.read.zero?
                         [:step, 2]
                       else
                         [:jump, params.last.read]
                        end

    msg = "(#{instruction}) moving with mode: #{move_instruction[0]}, val: #{move_instruction[1]}"
    { msg: msg, move_instruction: move_instruction }
  end
end

class I06 < I
  def initialize(addr, stack)
    instruction = stack[addr].to_s.rjust(4, '0')
    super(6, instruction, addr, stack)
  end

  def write
    move_instruction = if !params.first.read.zero?
                         [:step, 2]
                       else
                         [:jump, params.last.read]
                        end

    msg = "(#{instruction}) moving with mode: #{move_instruction[0]}, val: #{move_instruction[1]}"
    { msg: msg, move_instruction: move_instruction }
  end
end

class I07 < I
  def initialize(addr, stack)
    instruction = stack[addr].to_s.rjust(4, '0')
    instruction = instruction.to_s.rjust(5, '1')
    super(7, instruction, addr, stack)
  end

  def write
    store_val = params[0].read < params[1].read ? 1 : 0
    store_addr = params.last.read
    stack[store_addr] = store_val
    move_instruction = [:step, params_count]

    msg = "(#{instruction}) Writing #{store_val} to addr: #{store_addr}"
    { msg: msg, move_instruction: move_instruction }
  end
end

class I08 < I
  def initialize(addr, stack)
    instruction = stack[addr].to_s.rjust(4, '0')
    instruction = instruction.to_s.rjust(5, '1')
    super(7, instruction, addr, stack)
  end

  def write
      store_val = params[0].read == params[1].read ? 1 : 0
    store_addr = params.last.read
    stack[store_addr] = store_val
    move_instruction = [:step, params_count]

    msg = "(#{instruction}) Writing #{store_val} to addr: #{store_addr}"
    { msg: msg, move_instruction: move_instruction }
  end
end

class I99 < I
  def initialize(addr, stack)
    super(99, '99', addr, stack)
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
    @msgs = []
    @moves = []
  end

  attr_reader :program, :instruction_ptr, :msgs, :moves
  attr_reader :msgs, :moves

  def instruction_int
    program[instruction_ptr]
  end

  def move_ptr(mode, val)
    case mode
    when :step
      @instruction_ptr += val + 1
    when :jump
      @instruction_ptr = val
    end
  end

  def self.run(program)
    computer = new(program)
    loop do
      instruction = Instruction.build(computer.instruction_int, computer.instruction_ptr, program)
      result = instruction.write
      break unless result
      msg = result[:msg]
      move_instruction = result[:move_instruction]
      computer.msgs << msg
      computer.moves << move_instruction
      computer.move_ptr(*move_instruction)
    end
    puts computer.msgs
    computer
  end
end
