require 'parslet'


class IntLiteral < Struct.new(:val)
  def eval
    val.to_i
  end
end

class FloatLiteral < Struct.new(:val)
  def eval
    val.to_f
  end
end

class Addition < Struct.new(:left, :right)
  def eval
    left.eval + right.eval
  end
end


class CalcInterpreter < Parslet::Transform
  rule(int: simple(:val)) {
    IntLiteral.new(val)
  }
  
  rule(float: simple(:val)) {
    FloatLiteral.new(val)
  }
  
  rule(left: simple(:left), op: '+', right: simple(:right)) {
    Addition.new(left, right)
  }
end
