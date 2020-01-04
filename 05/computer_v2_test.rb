require "minitest/autorun"
require "./computer_v2.rb"

class TestComputer < Minitest::Test
  def test_full_program
    $stdin = StringIO.new("1\n")
    program = File.read('input.txt').split(',').map(&:to_i)
    messages = Computer.run(program).msgs
    assert_equal(
      ["writing 1 to addr: 225","writing 1101 (1 + 1101) to addr: 6","writing 239 (1 + 238) to addr: 225","writing 0 to stdout","writing 340 (68 * 5) to addr: 225","writing 83 (71 + 12) to addr: 225","writing 100 (31 + 69) to addr: 224","writing 0 (0 + -100) to addr: 224","writing 0 to stdout","writing 0 (8 * 0) to addr: 223","writing 2 (2 + 2) to addr: 224","writing 2 (2 + 2) to addr: 223","writing 87 (51 + 36) to addr: 224","writing 0 (-87 + 0) to addr: 224","writing 0 to stdout","writing 16 (8 * 16) to addr: 223","writing 2 (2 + 2) to addr: 224","writing 18 (18 + 2) to addr: 223","writing 77 (26 + 51) to addr: 225","writing 671 (11 * 61) to addr: 224","writing 0 (0 + -671) to addr: 224","writing 0 to stdout","writing 144 (144 * 8) to addr: 223","writing 5 (5 + 5) to addr: 224","writing 149 (149 + 5) to addr: 223","writing 136 (59 + 77) to addr: 224","writing 0 (-136 + 0) to addr: 224","writing 0 to stdout","writing 1192 (1192 * 8) to addr: 223","writing 1 (1 + 1) to addr: 224","writing 1193 (1193 + 1) to addr: 223","writing 47 (11 + 36) to addr: 225","writing 496 (31 * 16) to addr: 225","writing 1656 (24 * 69) to addr: 224","writing 0 (0 + -1656) to addr: 224","writing 0 to stdout","writing 9544 (8 * 9544) to addr: 223","writing 1 (1 + 1) to addr: 224","writing 9545 (1 + 9545) to addr: 223","writing 147 (60 + 87) to addr: 224","writing 0 (0 + -147) to addr: 224","writing 0 to stdout","writing 76360 (8 * 76360) to addr: 223","writing 2 (2 + 2) to addr: 224","writing 76362 (76362 + 2) to addr: 223","writing 2622 (38 * 69) to addr: 225","writing 129 (87 + 42) to addr: 225","writing 355 (71 * 5) to addr: 224","writing 0 (-355 + 0) to addr: 224","writing 0 to stdout","writing 610896 (8 * 610896) to addr: 223","writing 2 (2 + 2) to addr: 224","writing 610898 (2 + 610898) to addr: 223","writing 979 (11 * 89) to addr: 224","writing 0 (-979 + 0) to addr: 224","writing 0 to stdout","writing 4887184 (4887184 * 8) to addr: 223","writing 7 (7 + 7) to addr: 224","writing 4887191 (7 + 4887191) to addr: 223","writing 4071 (69 * 59) to addr: 225","writing 4887191 to stdout"],
      messages
    )
    $stdin = STDIN
  end

  def test_op_05
    program = [5, 1, 3, 99]
    moves = Computer.run(program).moves
    assert_equal [[:jump, 3]], moves
  end

  def test_op_05_noop
    program = [5, 0, 3, 99]
    moves = Computer.run(program).moves
    assert_equal [[:step, 2]], moves
  end

  def test_op_06
    program = [6, 0, 3, 99]
    moves = Computer.run(program).moves
    assert_equal [[:jump, 3]], moves
  end

  def test_op_06_noop
    program = [6, 1, 3, 99]
    moves = Computer.run(program).moves
    assert_equal [[:step, 2]], moves
  end

  def test_op_07
    program = [7, 0, 3, 5, 99]
    msgs = Computer.run(program).msgs
    moves = Computer.run(program).moves
    assert_equal ["Writing 1 to addr: 5"], msgs
    assert_equal [[:step, 3]], moves
  end

  def test_op_07_false
    program = [7, 3, 0, 5, 99]
    msgs = Computer.run(program).msgs
    moves = Computer.run(program).moves
    assert_equal ["Writing 0 to addr: 5"], msgs
    assert_equal [[:step, 3]], moves
  end

  def test_op_08
    program = [8, 3, 3, 5, 99]
    msgs = Computer.run(program).msgs
    moves = Computer.run(program).moves
    assert_equal ["Writing 1 to addr: 5"], msgs
    assert_equal [[:step, 3]], moves
  end

  def test_op_08_false
    program = [8, 3, 0, 5, 99]
    msgs = Computer.run(program).msgs
    moves = Computer.run(program).moves
    assert_equal ["Writing 0 to addr: 5"], msgs
    assert_equal [[:step, 3]], moves
  end
end

