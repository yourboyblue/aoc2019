masses = File.read('input.txt').split("\n").map(&:to_i)

total = 0
# masses.each do |mass|
#   module_and_fuel_mass = [mass]
#   last = module_and_fuel_mass.last
#   while last.positive? do
#     fuel = ((last / 3).round(0, half: :down) - 2)
#     module_and_fuel_mass << fuel
#   end
#   total += module_and_fuel_mass.sum
# end

puts total
