require "minitest/autorun"
require './spiral_path.rb'

class TestSpiralPath < Minitest::Test
  def test_middle
    x_range = 0..2
    y_range = 0..2
    c = [1,1]
    path = SpiralPath.find(xr: x_range, yr: y_range, c: c)
    assert_equal [[0, 1], [0, 2], [1, 2], [2, 2], [2, 1], [2, 0], [1, 0], [0, 0]], path
  end

  def test_top_border
    x_range = 0..2
    y_range = 0..2
    c = [1,0]
    path = SpiralPath.find(xr: x_range, yr: y_range, c: c)

    assert_equal [[0, 2], [1, 2], [2, 2], [0, 0], [0, 1], [1, 1], [2, 1], [2, 0]], path
  end

  def test_left_border
    x_range = 0..2
    y_range = 0..2
    c = [0,1]
    path = SpiralPath.find(xr: x_range, yr: y_range, c: c)

    assert_equal [[2, 2], [2, 1], [2, 0], [0, 2], [1, 2], [1, 1], [1, 0], [0, 0]], path
  end

  def test_bottom_right_corner
    x_range = 0..2
    y_range = 0..2
    c = [2,2]
    path = SpiralPath.find(xr: x_range, yr: y_range, c: c)

    assert_equal [[0, 1], [0, 2], [2, 0], [1, 0], [0, 0], [1, 2], [2, 1], [1, 1]], path
  end
end
