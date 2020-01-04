require 'pry'
class Layer
  def initialize(digits)
    @digits = digits
  end

  def digit_count(digit)
    @digits.count { |d| d == digit }
  end
end

class ElfImage
  def initialize(src, w, h)
    @src = src
    @w = w
    @h = h
  end

  def layers
    layers = []
    src_copy = @src.dup
    while !src_copy.empty? do
      layer = src_copy.shift(@w * @h)
      raise 'Corrupt layer' if layer.length < (@w * @h)

      layers << layer
    end
    layers
  end

  def combined_layers
    combined = []
    (@w * @h).times { |i| combined[i] = Array.new }
    layers.each { |l| l.each_with_index { |pixel, i| combined[i] << pixel } }
    combined
  end

  def visible_pixels
    combined_layers.map do |pixel_layer|
      pixel_layer.find { |p| p == 1 || p == 0 }
    end
  end

  def print
    # Make the output more readable
    pixels = visible_pixels.map { |vp| vp == 1 ? 'X' : ' ' }
    until pixels.empty?
      puts pixels.shift(@w).join
    end
  end
end

version = :v2
image = File.read('input.txt').strip.chars.map(&:to_i)

if version == :v1
  width, height = [25, 6]
  layers = []
  while !image.empty? do
    layer = image.shift(width * height)
    raise 'Corrupt layer' if layer.length < (width * height)

    layers << Layer.new(layer)
  end

  least_zeros = layers.min { |a, b| a.digit_count(0) <=> b.digit_count(0) }
  res = least_zeros.digit_count(1) * least_zeros.digit_count(2)
  puts res
end

if version == :v2
  width, height = [25, 6]
  elf_image = ElfImage.new(image, width, height)
  elf_image.print
end


