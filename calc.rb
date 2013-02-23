require './parser'
require './interpreter'


parser = CalcParser.new
interp = CalcInterpreter.new

ast = parser.parse('1336 + 1')
p interp.apply(ast).eval
