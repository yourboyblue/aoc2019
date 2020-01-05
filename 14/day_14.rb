require 'pry'

class Reaction
  def initialize(inputs, output)
    @quantity = output.quantity
    @output   = output.element

    @inputs = inputs
  end

  attr_reader :inputs, :output, :quantity

  def ore_only?
    @inputs.map { |i| i.element }.all? { |e| e == 'ORE' }
  end

  def input_elements
    inputs.map(&:element)
  end
end

Quantity = Struct.new(:quantity, :element)

def parse_element_qauntity(input)
  quantity = /\d+/.match(input)[0].to_i
  element  = /[A-Z]+/.match(input)[0]
  Quantity.new(quantity, element)
end

def decompose(element, reactions, required_elements)
  reactions[element].inputs.each do |i|
    current_required = required_elements[i.element]
    required_elements[i.element] = current_required + i.quantity
  end
end

def required_reactions_count(element, reactions, required_elements)
  qty_required = required_elements[element]
  qty_reaction = reactions[element].quantity
  (qty_required.to_f / qty_reaction).ceil
end

reaction_desciptions = File.read('input.txt').split("\n")

decomposed = []
reactions = {}
required_elements = Hash.new(0)

reaction_desciptions.each do |desc|
  ipt, out = desc.split(' => ')
  inputs = ipt.split(', ').map { |i| parse_element_qauntity(i) }
  output = parse_element_qauntity(out)
  reactions[output.element] = Reaction.new(inputs, output)
end


while true do
  if !required_elements.empty?
    # Find an element that doesn't reduce to ore, and won't need to be decomposed
    # again (because it's an input to an as yet un-decomposed reaction)
    el = required_elements.find do |req_el, _v|
      current_required_inputs = reactions.values_at(*reactions.keys - decomposed).flat_map(&:input_elements)
      !reactions[req_el].ore_only? && !current_required_inputs.include?(req_el)
    end[0]

    decomposed << el
    # print "#{el}: "
    reactions_required = required_reactions_count(el, reactions, required_elements)
    reactions_required.times { decompose(el, reactions, required_elements) }
    required_elements.delete(el)
  else
    decompose('FUEL', reactions, required_elements)
    decomposed << 'FUEL'
  end

  # puts required_elements
  break if required_elements.all? { |k, _v| reactions[k].ore_only? }
end

required_ore = Hash.new(0)
required_elements.keys.each do |el|
  reactions_required = required_reactions_count(el, reactions, required_elements)
  reactions_required.times { decompose(el, reactions, required_ore) }
end
puts required_ore

