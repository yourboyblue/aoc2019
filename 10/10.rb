require 'set'

class Asteroid
  def initialize(x:, y:)
    @x = x
    @y = y
  end

  attr_reader :x, :y

  # Break axis ties down and to the right
  # 4 | 1
  # --+--
  #   |X
  # 3 | 2
  def quadrant(station)
    case [x <=> station.x, y <=> station.y]
    when [0, -1], [1, -1] then 1
    when [0, 1], [1, 1], [1, 0] then 2
    when [-1, 1], [-1, 0] then 3
    when [-1, -1] then 4
    end
  end

  def slope(station)
    numerator   = (x - station.x).abs
    denominator = (y - station.y).abs
    return 90 if numerator.zero?  # veritical slope
    return 0 if denominator.zero? # horizontal slope

    Rational(numerator, denominator).rationalize
  end

  def mathattan_to(station)
    (x - station.x).abs + (y - station.y).abs
  end
end

class Quadrant
  def initialize(number:, station:, asteroids: [])
    @number = number
    @station = station
    @asteroids = asteroids
  end

  attr_reader :number

  def asteroids_by_slope
    @asteroids.group_by { |a| a.slope(@station) }
  end

  def clockwise_slopes
    rational_slopes = slopes.to_a - [0, 90]
    case @number
    when 1
      rational_slopes.sort.unshift(90)
    when 2
      rational_slopes.sort.reverse.unshift(0).push(90)
    when 3
      rational_slopes.sort.push(0)
    when 4
      rational_slopes.sort.reverse
    end
  end

  def slopes
    Set.new(@asteroids.map { |a| a.slope(@station) })
  end
end

class MonitoringStation
  def initialize(asteroids)
    @asteroids = asteroids
  end

  def find_station_location
    @asteroids.map { |station| [station, visible_count_from(station)] }
              .max { |station_a, station_b| station_a[1] <=> station_b[1] }
  end

  def visible_count_from(station)
    quadrants(station).sum { |q| q.slopes.length }
  end

  def quadrants(station)
    asteroids = @asteroids - [station]
    asteroids_by_quadrant = asteroids.group_by { |a| a.quadrant(station) }
    asteroids_by_quadrant.map do |q, q_asteroids|
      Quadrant.new(number: q, asteroids: q_asteroids, station: station)
    end.sort_by(&:number)
  end

  def vaporize_from(station)
    vaporization_queues = []
    quadrants(station).each do |quadrant|
      quadrant.clockwise_slopes.each do |slope|
        asteroids_at_slope = quadrant.asteroids_by_slope[slope]
        next unless asteroids_at_slope

        vaporization_queues << asteroids_at_slope.sort_by { |a| a.mathattan_to(station) }
      end
    end

    vaporized = []
    asteroids_remaining = @asteroids.length - 1

    while asteroids_remaining > 0 do
      vaporization_queues.each do |queue|
        asteroid = queue.shift
        next unless asteroid

        asteroids_remaining -= 1
        vaporized << asteroid
      end
    end
    vaporized
  end

  # Print sequential vaporization frames for debugging
  def vaporization_frames(station)
    x_min = @asteroids.map(&:x).min
    x_max = @asteroids.map(&:x).max
    y_min = @asteroids.map(&:y).min
    y_max = @asteroids.map(&:y).max

    vaporized = vaporize_from(station)
    asteroids = @asteroids - [station]

    until vaporized.empty?
      nine = vaporized.shift(9)
      asteroids = asteroids - nine
      frame = (y_min..y_max).map { |row| Array.new(x_max + 1, '.') }.tap do |f|
        f[station.y][station.x] = 'X'
      end
      asteroids.each { |a| frame[a.y][a.x] = '#' }
      nine.each_with_index do |v, i|
        frame[v.y][v.x] = i + 1
      end
      frame.each { |row| puts row.join('') }
      puts ''
    end
  end
end

map_rows = File.read('input.txt').split("\n").map(&:chars)
asteroids = map_rows.flat_map.with_index do |row, y|
              row.map.with_index { |indicator, x| Asteroid.new(x: x, y: y) if indicator == '#' }
            end.compact

# Part 1
monitoring_station = MonitoringStation.new(asteroids)
station_location, count = monitoring_station.find_station_location
puts "[#{station_location.x}, #{station_location.y}]: #{count}"

# Part 2
# monitoring_station.vaporization_frames(station_location) # print frames for debugging
vaporized = monitoring_station.vaporize_from(station_location)
two_hundred = vaporized[199]
puts (two_hundred.x * 100) + two_hundred.y
