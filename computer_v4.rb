require 'pry'
class IntComputer
  def self.run(mem, input: [], output: [])
    computer = new(mem, input, output)
    computer.cycle until computer.op == 99
    puts computer.output.join
  end

  def initialize(mem, input, output)
    @mem      = mem
    @ptr      = 0
    @rb       = 0
    @op       = 0
    @input    = input
    @output   = output # option write buffer for chaining
    @p_size   = [nil, 4, 4, 2, 2, 3, 3, 4, 4, 2] # nil for effective 1 index
    @overflow = {}
  end

  attr_reader :op, :output

  def cycle
    @op = @mem[@ptr] % 100

    case @op
    when 99 then return
    when 1
      write(2, reads[0] + reads[1])
    when 2
      write(2, reads[0] * reads[1])
    when 3
      return unless input = @input.pop # noop if waiting on input
      write(0, input)
    when 4
      output << reads[0]
    when 5
      jump = reads[0]
      return @ptr = reads[1] if jump > 0
    when 6
      jump = reads[0]
      return @ptr = reads[1] if jump.zero?
    when 7
      write(2, reads[0] < reads[1] ? 1 : 0)
    when 8
      write(2, reads[0] == reads[1] ? 1 : 0)
    when 9
      @rb += reads[0]
    end
    @ptr += @p_size[@op]
  rescue
    binding.pry
  end

  def modes
    modes = @mem[@ptr].to_s.chars.tap { |chars| chars.pop(2) } # Remove instruction chars
    defaults = Array.new(@p_size[@op] - 1, 0)
    defaults[-1] = 1 if [1,2,3,7,8].include?(@op) # write mode in last position defaults to immediate
    defaults.map.with_index { |default, i| modes.pop || default }.map(&:to_i)
  end

  def reads
    modes.map.with_index(1) do |mode, i|
      addr = case mode
      when 0 then @mem[@ptr + i]
      when 1 then @ptr + i
      when 2 then @mem[@ptr + i] + @rb
      end

      (addr + 1) > @mem.length ? @overflow.fetch(addr, 0) : @mem[addr]
    end
  end

  def write(pos, val)
    addrs = modes.map.with_index(1) do |mode, i|
      case mode
      when 0,1 then @mem[@ptr + i]
      when 2 then @mem[@ptr + i] + @rb
      end
    end
    return @overflow[addrs[pos]] = val if (addrs[pos] + 1) > @mem.length

    @mem[addrs[pos]] = val
  end
end
