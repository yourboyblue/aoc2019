require 'set'

data = File.read('input.txt').split("\n")

# pt. 1
orbits = Hash.new { |h,k| h[k] = [] }
data.each do |datapoint|
  center, orbiter = datapoint.split(')')
  orbits[center] << orbiter
end

count = 0
stack = orbits['COM'].map { |planet| [1, planet] }
while true do
  break if stack.empty?
  level, planet, center = stack.pop
  count += level
  level += 1
  orbits[planet].each { |orbiter| stack << [level, orbiter] }
end
puts count

# pt. 2
orbits = {}
data.each do |datapoint|
  center, orbiter = datapoint.split(')')
  orbits[orbiter] = center
end

planets_on_path = {}
planet_your_path = orbits['YOU']
planet_santa_path = orbits['SAN']
root = nil
level = 0
while true do
  root = [level, planet_your_path] and break if planets_on_path[planet_your_path]
  root = [level, planet_santa_path] and break if planets_on_path[planet_santa_path]
  planets_on_path[planet_your_path] = level
  planets_on_path[planet_santa_path] = level
  planet_your_path = orbits[planet_your_path]
  planet_santa_path = orbits[planet_santa_path]
  level += 1
end
puts planets_on_path[root[1]] + root[0]


