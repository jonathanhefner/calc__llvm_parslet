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

class OpRight < Struct.new(:op, :right)
  def eval(left_val)
    case op
      when '+'
        left_val + right.eval
      when '-'
        left_val - right.eval
      when '*'
        left_val * right.eval
      when '/'
        left_val / right.eval
    end
  end
end

class OpSequence < Struct.new(:left, :rights)
  def eval
    rights.reduce(left.eval){|l, r| r.eval(l) }
  end
end



class CalcInterpreter < Parslet::Transform
  rule(int: simple(:val)) {
    IntLiteral.new(val)
  }
  
  rule(float: simple(:val)) {
    FloatLiteral.new(val)
  }
  
  rule(op: simple(:op), right: subtree(:right)) {
    OpRight.new(op, right)
  }
  
  rule(left: subtree(:left), rights: sequence(:rights)) {
    OpSequence.new(left, rights)
  }
end
