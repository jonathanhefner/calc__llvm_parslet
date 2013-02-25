require './parser'
require './interpreter'


parser = CalcParser.new
interp = CalcInterpreter.new

input = [
  '1336 + 1',
  '+1 + +1',
  '+1++1',
  '-1 + 1',
  '1.1 + 2.2',
  '0.5 + -0.4',
  '.9 + .1',
  '1 + 2 + 3',
  '1 * 2 * 3',
  '1 * 2 + 3',
  '1 + 2 * 3',
  '1 * (2 + 3)',
  '1 * ((2 + 3))',
  '(1 + 2) * 3',
  '(1) + (2 * 3)',
]
  
input.each do |i|
  puts i
  ast = parser.parse(i)
  puts "    #{ast}"
  ast = interp.apply(ast)
  puts "    #{ast}"
  result = ast.eval
  puts "    #{result}"
  puts ''
end