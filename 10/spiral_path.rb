# This class is a working part of an aborted first solution to this problem,
# which generated a spiral path to traverse a grid space from a reference
# coordinate.
class SpiralPath
  def self.find(xr:, yr:, c:)
    new(xr, yr, c).path
  end

  def initialize(x_range, y_range, coordinate)
    @x_range = x_range
    @y_range = y_range
    @x = coordinate[0]
    @y = coordinate[1]
  end

  def path
    all_coords = []
    # stack order of coordinates from furthest to reference
    u_coords = (@y_range.min...@y).to_a.reverse
    r_coords = (@x..@x_range.max).to_a.tap { |a| a.shift} # drop reference coord since we can't use inclusive range
    d_coords = (@y..@y_range.max).to_a.tap { |a| a.shift} # drop reference coord since we can't use inclusive range
    l_coords = (@x_range.min...@x).to_a.reverse

    ring_count = [u_coords, r_coords, d_coords, l_coords].map(&:length).max
    ring_count.times do
      uy = u_coords.shift
      rx = r_coords.shift
      dy = d_coords.shift
      lx = l_coords.shift

      up = []
      rt = []
      dn = []
      lt = []

      # clockwise, starting top-left
      up = ((lx || @x_range.min)..(rx || @x_range.max)).to_a.map { |x| [x, uy] } if uy
      rt = ((uy || @y_range.min)..(dy || @y_range.max)).to_a.map { |y| [rx, y] } if rx
      dn = ((lx || @x_range.min)..(rx || @x_range.max)).to_a.reverse.map { |x| [x, dy] } if dy
      lt = ((uy || @y_range.min)..(dy || @y_range.max)).to_a.reverse.map { |y| [lx, y] } if lx

      (up | rt | dn | lt).each { |c| all_coords.unshift(c) }
    end
    all_coords
  end
end
