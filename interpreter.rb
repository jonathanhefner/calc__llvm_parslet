require 'parslet'


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
