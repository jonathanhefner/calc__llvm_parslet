require 'parslet'


class CalcParser < Parslet::Parser
  rule(:space) { match('\s').repeat(1) }
  rule(:space?) { space.maybe }
  rule(:sign) { match('[+-]') }
  rule(:sign?) { sign.maybe }
  rule(:digit) { match('[0-9]') }
  rule(:digits) { digit.repeat(1) }
  rule(:digits?) { digit.repeat(0) }

  rule(:integer) { (sign? >> digits).as(:int) }
  rule(:floating_point) { (sign? >> digits? >> match('[.]') >> digits).as(:float) }
  rule(:number) { floating_point | integer }
  rule(:operator) { match('[+]') }
  
  rule(:sum) { number.as(:left) >> space? >> operator.as(:op) >> space? >> expression.as(:right) }
  
  rule(:expression) { sum | number }
  root(:expression)
end
