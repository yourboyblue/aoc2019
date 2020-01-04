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

  def rings
    rings = []
    n_coords = (@y_range.max..@y).to_a
    e_coords = (@x_range.max..@x).to_a
    s_coords = (@y_range.min..@y).to_a
    w_coords = (@x_range.min..@x).to_a

    ring_count.times do
      ny = n_coords.pop
      ex = e_coords.pop
      sy = s_coords.pop
      wx = w_coords.pop

      tp = []
      rt = []
      dn = []
      lt = []

      tp = ((wx || @x_range.min)..(ex || @x_range.max)).to_a.map { |x| [x, ny] } if ny
      rt = ((ny || @y_range.max)..(sy || @x_range.min)).to_a.map { |y| [ex, y] } if ex
      dn = ((ex || @x_range.max)..(wx || @x_range.min)).to_a.map { |x| [x, sy] } if sy
      lt = ((sy || @x_range.min)..(ny || @y_range.max)).to_a.map { |y| [wx, y] } if wx

      rings.unshift(Set.new(lt + dn + rt + tp))
    end
    rings
  end

  def ring_count
    [@x_range.max - @x, @x + @x_range.min, @y_range.max - @y, @y + @y_range.min].max
  end
end
