require './parser'


class IntLiteral
  def eval
    val.to_i
  end
end


class FloatLiteral
  def eval
    val.to_f
  end
end


class OpRight
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


class OpSequence
  def eval
    rights.reduce(left.eval){|l, r| r.eval(l) }
  end
end
