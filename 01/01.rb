masses = File.read('input.txt').split("\n").map(&:to_i)
fuel = masses.sum { |m| ((m / 3).round(0, half: :down) - 2) }
puts fuel
