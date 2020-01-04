require '../computer_v4.rb'

class Direction
  def initialize(direction:, right:, left:)
    @direction = direction
    @right = right
    @left = left
  end

  attr_reader :direction, :right, :left
end

class Robot
  DIRECTIONS = [
    Direction.new(direction: :u, right: :r, left: :l),
    Direction.new(direction: :r, right: :d, left: :u),
    Direction.new(direction: :d, right: :l, left: :r),
    Direction.new(direction: :l, right: :u, left: :d)
  ]

  def initialize(program)
    @curr_d = :u
    @visited = [[0,0]]
    @panel_colors = Hash.new { |h, xy| h[xy] = 0 }

    @program_input  = []
    @program_output = []
    @program = IntComputer.new(program, @program_input, @program_output)
  end

  def paint
    while true do
      color, turn_d = next_instruction
      break if color == 99 # computer returned halt

      paint_panel(current_panel, color)
      panel = move(turn(turn_d))
    end
    @visited
  end

  def next_instruction
    @program_input << @panel_colors[current_panel]
    until instruction_retrieved?
      @program.cycle
    end

    @program_output.shift(2)
  end

  def instruction_retrieved?
    return true if @program_output[0] == 99

    @program_output.length == 2
  end

  def current_panel
    @visited.last
  end

  def turn(turn_d)
    prev_d = DIRECTIONS.find { |d| d.direction == @curr_d }
    @curr_d = turn_d == 0 ? prev_d.left : prev_d.right
  end

  def move(move_d)
    curr_pos = @visited[-1]
    case move_d
    when :u
      @visited << [curr_pos[0], curr_pos[1] + 1]
    when :r
      @visited << [curr_pos[0] + 1, curr_pos[1]]
    when :d
      @visited << [curr_pos[0], curr_pos[1] - 1]
    when :l
      @visited << [curr_pos[0] - 1, curr_pos[1]]
    end

    current_panel
  end

  def paint_panel(panel, color)
    @panel_colors[panel] = color
  end
end

class Day11
  def self.part_1
    new.part_1
  end

  def initialize
    @program = File.read('input.txt').split(',').map(&:to_i)
    @robot = Robot.new(@program)
  end

  attr_reader :robot

  def part_1
    robot.paint.uniq.length
  end
end
