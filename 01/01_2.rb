masses = File.read('input.txt').split("\n").map(&:to_i)

def fuel_for_mass(mass)
  ((mass / 3).round(0, half: :down) - 2)
end

total = masses.sum do |mass|
  masses_for_module = [mass]
  while masses_for_module.last.positive? do
    fuel = fuel_for_mass(masses_for_module.last)
    masses_for_module << fuel
  end
  masses_for_module.shift
  masses_for_module.pop
  masses_for_module.sum
end

puts total
