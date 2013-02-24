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
  rule(:mult_op) { match('[*/]').as(:op) >> space? }
  rule(:add_op) { match('[+-]').as(:op) >> space? }
  
  # parslet implements PEG, therefore no left-recursion
  rule(:p1) { (num.as(:left) >> (mult_op >> p1.as(:right)).repeat(1).as(:rights)) | num }
  rule(:p0) { (p1.as(:left) >> (add_op >> p1.as(:right)).repeat(1).as(:rights)) | p1 }
  
  root(:p0)
end
