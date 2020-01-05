require '../computer_v4.rb'

# Helper class for animating the game state
class ScreenPrinter
  class << self
    def print_n(x, y, entity)
      move = "\033[#{y + 1};#{x + 1}H"
      print move
      print entity_c(entity)
    end

    def entity_c(entity)
      case entity
      when 0 then ' '
      when 1 then '='
      when 2 then '#'
      when 3 then '-'
      when 4 then 'o'
      end
    end
  end
end

def process_instruction(x, y, entity, state, scores)
  return scores << entity if [x, y] == [-1, 0]
  state[[x, y]] = entity
  ScreenPrinter.print_n(x, y, entity)
  # sleep_time = (entity == 4 || entity == 3) ? 0.2 : 0.001
  # sleep sleep_time
end

def get_input(target, state)
  return 0 unless target
  x, y = state.select { |k, v| v == 3 }.keys.first
  target[0] <=> x
end

def paddle_position(state)
  pair = state.select { |k, v| v == 3 }
  pair.keys.first unless pair.empty?
end

program = File.read('input.txt').split(',').map(&:to_i)
# paddle_positions = [[19,19]] # if finding solving for the first time
paddle_positions = [[19,19], [25,19], [25,19], [25,19], [33,19], [33,19], [33,19], [31,19], [31,19], [31,19], [33,19], [33,19], [33,19], [31,19], [31,19], [31,19], [29,19], [29,19], [31,19], [31,19], [31,19], [31,19], [29,19], [29,19], [29,19], [27,19], [27,19], [33,19], [33,19], [33,19], [17,19], [11,19], [5,19], [3,19], [3,19], [3,19], [11,19], [19,19], [19,19], [19,19], [19,19], [19,19], [21,19], [15,19], [9,19], [9,19], [9,19], [9,19], [9,19], [3,19], [3,19], [3,19], [3,19], [3,19], [3,19], [3,19], [3,19], [15,19], [15,19], [13,19], [13,19], [13,19], [13,19], [13,19], [27,19], [35,19], [35,19], [35,19], [35,19], [35,19], [35,19], [35,19], [35,19], [33,19], [33,19], [33,19], [33,19], [17,19], [7,19], [5,19], [5,19], [9,19], [23,19], [23,19], [21,19], [21,19], [21,19], [27,19], [27,19], [27,19], [29,19], [29,19], [3,19], [19,19], [19,19], [19,19], [19,19], [19,19], [19,19], [19,19], [19,19], [19,19], [19,19], [21,19], [23,19], [5,19], [31,19], [31,19], [5,19], [33,19], [33,19], [5,19], [31,19], [7,19], [7,19], [31,19], [5,19], [33,19], [33,19], [5,19], [31,19], [7,19], [9,19], [29,19], [29,19], [9,19], [9,19], [29,19], [7,19], [31,19], [5,19], [33,19], [33,19], [5,19], [31,19], [7,19], [29,19], [9,19], [9,19], [29,19], [7,19], [31,19], [5,19], [33,19], [3,19], [3,19], [33,19], [5,19], [31,19], [7,19], [29,19], [9,19], [9,19], [29,19], [7,19], [31,19], [5,19], [33,19], [3,19], [3,19], [33,19], [5,19], [31,19], [7,19], [29,19], [9,19], [15,19], [15,19], [21,19], [21,19], [15,19], [23,19], [23,19], [15,19], [21,19], [17,19], [17,19], [21,19], [15,19], [23,19], [23,19], [15,19], [21,19], [17,19], [17,19], [21,19], [15,19], [23,19], [13,19], [25,19], [25,19], [13,19], [23,19], [15,19], [21,19], [17,19], [19,19], [19,19], [17,19], [21,19], [15,19], [23,19], [13,19], [25,19]]
solved = false

until solved do
  computer = IntComputer.new(program, input = [], output = [])

  state = {}
  scores = []
  halt = false
  targets = paddle_positions.dup
  target = targets.shift

  ball_positions = []

  until halt do
    halt = output.last == 99
    pp = paddle_position(state)

    if pp == target
      input.clear
      input << 0
    end

    # enough info to update state
    if output.length == 3
      x, y, entity = *output.pop(3)
      ball_positions << [x, y] if entity == 4
      process_instruction(x, y, entity, state, scores)

      # ball hit paddle, get a new target
      if entity == 4 && y == 18
        target = targets.shift if target
      end
    end

    input << get_input(target, state) if input.empty?

    computer.cycle
  end

  # find all the places we know the paddle should be so far
  paddle_positions = ball_positions.select { |(_x, y)| y == 18 }.map { |x, y| [x, y + 1] }

  block_count = state.values.count { |v| v == 2 }
  solved = block_count.zero? # any blocks left?
  puts scores.last if solved
end
