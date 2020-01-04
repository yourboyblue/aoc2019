count = 0
(136760...595730).each do |i|
  pairs = false
  descends = false
  a, b = 0, 1
  digits = i.to_s.chars.map(&:to_i)
  while b < digits.length && !descends
    pairs = true if digits[a] == digits[b] && !pairs
    descends = true if digits[a] > digits[b]
    a += 1
    b += 1
  end
  count += 1 if pairs && !descends
end

puts count
