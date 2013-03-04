require './interpreter'
require './compiler'


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
  ast = Calc.parse(i)
  puts "    #{ast}"
  puts "    #{Calc.interpret(ast)}"
  puts "    #{Calc.compile_run(ast)}"
  puts ''
end
