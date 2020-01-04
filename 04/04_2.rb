count = 0
(136760...595730).each do |i|
  runs = []
  descends = false
  a, b = 0, 1
  digits = i.to_s.chars.map(&:to_i)
  run = 1
  while b < digits.length && !descends
    if digits[a] == digits[b]
      run += 1
      runs << run if b == digits.length - 1
    else
      runs << run
      run = 1
    end
    descends = true if digits[a] > digits[b]
    a += 1
    b += 1
  end
  count += 1 if runs.find { |n| n == 2 } && !descends
end

puts count
