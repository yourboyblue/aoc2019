require 'pry'

class Moon
  def initialize(x:, y:, z:)
    @position = { x: x, y: y, z: z }
    @velocity = { x: 0, y: 0, z: 0 }
  end

  attr_reader :position

  def apply_gravity(**args)
    @velocity.each_pair { |axis, velocity| @velocity[axis] = @velocity[axis] + args[axis]}
  end

  def update_position
    @position.each_pair { |axis, n| @position[axis] = n + @velocity[axis] }
  end

  def energy
    @position.values.sum(&:abs) * @velocity.values.sum(&:abs)
  end

  def state
    @position.values.zip(@velocity.values)
  end
end

class GravitySimulator
  def initialize(moons)
    @moons = moons
  end

  def moon_pairs
    @moon_pairs ||= @moons.combination(2)
  end

  def step(n = 1)
    n.times do |i|
      moon_pairs.each do |a, b|
        a_velocities = { x: 0, y: 0, z: 0 }
        a_velocities.keys.each { |axis| a_velocities[axis] = b.position[axis] <=> a.position[axis] }
        a.apply_gravity(a_velocities)

        b_velocities = a_velocities.transform_values { |v| v * -1 }
        b.apply_gravity(b_velocities)
      end
      @moons.each(&:update_position)
    end

    @moons
  end

  def state
    @moons.reduce([[], [], []]) do |arr, moon|
      [
        arr[0] + moon.state[0],
        arr[1] + moon.state[1],
        arr[2] + moon.state[2]
      ]
    end
  end
end

moons = File.read('input.txt').split("\n").map do |moon_string|
  moon_args =
    /(?<x>(?<=x\=)[\d\-]+).*(?<y>(?<=y\=)[\d\-]+).*(?<z>(?<=z\=)[\d\-]+)/
      .match(moon_string)
      .named_captures
      .transform_keys!(&:to_sym)
      .transform_values!(&:to_i)

  Moon.new(**moon_args)
end

# part 1
simulator = GravitySimulator.new(moons)
puts simulator.step(1000).sum(&:energy)

# part 2
simulator = GravitySimulator.new(moons)
i_x_state, i_y_state, i_z_state = simulator.state
periods = [nil, nil, nil]
step = 0
until periods.all? do
  step += 1
  simulator.step
  x_state, y_state, z_state = simulator.state
  periods[0] = step if !periods[0] && i_x_state == x_state
  periods[1] = step if !periods[1] && i_y_state == y_state
  periods[2] = step if !periods[2] && i_z_state == z_state
end
puts periods.reduce(&:lcm)

