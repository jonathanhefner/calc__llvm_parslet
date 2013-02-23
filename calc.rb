require 'parslet'

class CalcParser < Parslet::Parser
  rule(:space) { match('\s').repeat(1) }
  rule(:space?) { space.maybe }

  rule(:integer) { match('[0-9]').repeat(1).as(:int) }
  rule(:operator) { match('[+]') }
  
  rule(:sum) { integer.as(:left) >> space? >> operator.as(:op) >> space? >> expression.as(:right) }
  
  rule(:expression) { sum | integer }
  root(:expression)
end


class IntLit < Struct.new(:val)
  def eval
    val.to_i
  end
end

class Addition < Struct.new(:left, :right)
  def eval
    left.eval + right.eval
  end
end


class CalcInterpreter < Parslet::Transform
  rule(int: simple(:int)) {
    IntLit.new(int)
  }
  
  rule(left: simple(:left), op: '+', right: simple(:right)) {
    Addition.new(left, right)
  }
end




parser = CalcParser.new
interp = CalcInterpreter.new

ast = parser.parse('1336 + 1')
p interp.apply(ast).eval
