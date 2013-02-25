require 'parslet'


class CalcParser < Parslet::Parser
  rule(:space) { match('\s').repeat(1) }
  rule(:space?) { space.maybe }
  rule(:sign) { match('[+-]') }
  rule(:sign?) { sign.maybe }
  rule(:digit) { match('[0-9]') }
  rule(:digits) { digit.repeat(1) }
  rule(:digits?) { digit.repeat(0) }

  rule(:int) { (sign? >> digits).as(:int) >> space? }
  rule(:float) { (sign? >> digits? >> match('[.]') >> digits).as(:float) >> space?}
  rule(:num) { float | int }
  rule(:lparen) { match('[(]') >> space? }
  rule(:rparen) { match('[)]') >> space? }
  rule(:mult_op) { match('[*/]').as(:op) >> space? }
  rule(:add_op) { match('[+-]').as(:op) >> space? }
  
  # parslet implements PEG, therefore no left-recursion
  rule(:p2) { (lparen >> p0 >> rparen) | num }
  rule(:p1) { (p2.as(:left) >> (mult_op >> p2.as(:right)).repeat(1).as(:rights)) | p2 }
  rule(:p0) { (p1.as(:left) >> (add_op >> p1.as(:right)).repeat(1).as(:rights)) | p1 }
  
  root(:p0)
end


class IntLiteral < Struct.new(:val)
  def float?
    false
  end
end


class FloatLiteral < Struct.new(:val)
  def float?
    true
  end
end


class OpRight < Struct.new(:op, :right)
  def float?
    right.float?
  end
end


class OpSequence < Struct.new(:left, :rights)
  def float?
    left.float? || rights.any?{|r| r.float? }
  end
end


class CalcTransform < Parslet::Transform
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
