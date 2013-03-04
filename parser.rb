require 'parslet'


module Calc

  class Parser < Parslet::Parser
    rule(:sp) { match('\s').repeat(1) }
    rule(:sp?) { sp.maybe }
    rule(:sign) { match('[+-]') }
    rule(:sign?) { sign.maybe }
    rule(:digit) { match('[0-9]') }
    rule(:digits) { digit.repeat(1) }
    rule(:digits?) { digit.repeat(0) }
    rule(:decimal) { match('[.]') }

    rule(:int) { sp? >> (sign? >> digits).as(:int) >> sp? }
    rule(:float) { sp? >> (sign? >> digits? >> decimal >> digits).as(:float) >> sp?}
    rule(:num) { float | int }
    rule(:lparen) { sp? >> match('[(]') >> sp? }
    rule(:rparen) { sp? >> match('[)]') >> sp? }
    rule(:mult_op) { sp? >> match('[*/]').as(:op) >> sp? }
    rule(:add_op) { sp? >> match('[+-]').as(:op) >> sp? }
    
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


  class Transform < Parslet::Transform
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


  def self.parse(src)
    Transform.new.apply(Parser.new.parse(src))
  end
  
end