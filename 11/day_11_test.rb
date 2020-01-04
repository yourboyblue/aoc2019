require './day_11.rb'
require 'minitest/autorun'

class TestDay11 < Minitest::Test
  def setup
    @robot = Day11.new.robot
  end

  def test_turn_left
    assert_equal :l, @robot.turn(0)
  end

  def test_turn_right
    assert_equal :r, @robot.turn(1)
  end

  def test_spin_right
    directions = []
    4.times { directions << @robot.turn(1) }

    assert_equal [:r, :d, :l, :u], directions
  end

  def test_move
    @robot.move(:u)
    assert_equal [0,1], @robot.current_panel
    @robot.move(:l)
    assert_equal [-1,1], @robot.current_panel
    @robot.move(:d)
    assert_equal [-1,0], @robot.current_panel
    @robot.move(:r)
    assert_equal [0,0], @robot.current_panel
  end

  def test_part_1
    assert_equal Day11.part_1, 2141
  end
end
