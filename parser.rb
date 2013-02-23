require 'parslet'


class CalcParser < Parslet::Parser
  rule(:space) { match('\s').repeat(1) }
  rule(:space?) { space.maybe }
  rule(:sign) { match('[+-]') }
  rule(:sign?) { sign.maybe }
  rule(:digit) { match('[0-9]') }

  rule(:integer) { (sign? >> digit.repeat(1)).as(:int) }
  rule(:operator) { match('[+]') }
  
  rule(:sum) { integer.as(:left) >> space? >> operator.as(:op) >> space? >> expression.as(:right) }
  
  rule(:expression) { sum | integer }
  root(:expression)
end
