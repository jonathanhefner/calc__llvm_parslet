require './parser'
require './interpreter'


parser = CalcParser.new
interp = CalcInterpreter.new

input = [
  '1336 + 1',
  '+1 + +1',
  '+1++1',
  '-1 + 1'
]
  
input.each do |i|
  ast = parser.parse(i)
  result = interp.apply(ast).eval

  puts i
  puts "TREE #{ast}"
  puts "EVAL #{result}"
  puts ''
end