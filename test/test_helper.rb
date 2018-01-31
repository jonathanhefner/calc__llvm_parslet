$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "minitest/autorun"


class Minitest::Test
end


module CalcTest

  def self.numeric_variants(str_vals)
    ["", "+", "-"].flat_map do |sign|
      (0..2).flat_map do |leading_zeros|
        str_vals.map do |str, val|
          ["#{sign}#{"0" * leading_zeros}#{str}", (sign == "-" ? -1 : 1) * val]
        end
      end
    end
  end

  DIGITS = ("0".."9").each_with_index.to_a

  MULTI = (1..3).flat_map do |repeat|
    DIGITS.map do |str, val|
      [str * repeat, repeat.times.reduce(0){|sum, i| sum * 10 + val } ]
    end
  end

  MULTI_FLOATS = MULTI.map do |str, val|
    [".#{str}", val / (10.0 ** str.length)]
  end

  INTEGER_LITERALS = numeric_variants(MULTI)

  FLOAT_LITERALS = numeric_variants(MULTI_FLOATS)

  OPERATOR_PRECEDENCE = { "*" => 0, "/" => 0, "+" => 1, "-" => 1 }

  def test_integer_literals
    INTEGER_LITERALS.each{|str, val| assert_integer_result(val, str) }
  end

  def test_float_literals
    FLOAT_LITERALS.each{|str, val| assert_float_result(val, str) }
  end

  def test_parens
    (1..3).each do |nest|
      assert_integer_result(42, "#{'(' * nest}42#{')' * nest}")
    end
  end

  def test_integer_addition
    DIGITS.each do |str, val|
      assert_integer_result((val * 10) + val, "#{str}0+#{str}")
    end
  end

  def test_integer_subtraction
    DIGITS.each do |str, val|
      assert_integer_result((val * 10) - val, "#{str}0-#{str}")
    end
  end

  def test_integer_multiplication
    DIGITS.each do |str, val|
      assert_integer_result((val * 10) * val, "#{str}0*#{str}")
    end
  end

  def test_integer_division
    DIGITS.each do |str, val|
      if val == 0
        # undefined
      else
        assert_integer_result((val * 10) / val, "#{str}0/#{str}")
      end
    end
  end

  def test_float_addition
    DIGITS.each do |str, val|
      assert_float_result(val + (val / 10.0), "#{str}+.#{str}")
    end
  end

  def test_float_subtraction
    DIGITS.each do |str, val|
      assert_float_result(val - (val / 10.0), "#{str}-.#{str}")
    end
  end

  def test_float_multiplication
    DIGITS.each do |str, val|
      assert_float_result(val * (val / 10.0), "#{str}*.#{str}")
    end
  end

  def test_float_division
    DIGITS.each do |str, val|
      if val == 0
        assert_float_result(Float::NAN, "#{str}/.#{str}")
      else
        assert_float_result(val / (val / 10.0), "#{str}/.#{str}")
      end
    end
  end

  def test_operator_precedence
    OPERATOR_PRECEDENCE.keys.product(OPERATOR_PRECEDENCE.keys).each do |op1, op2|
      expected = OPERATOR_PRECEDENCE[op1] <= OPERATOR_PRECEDENCE[op2] ?
        result("#{DIGITS[result("3#{op1}2")][0]}#{op2}1") :
        result("3#{op1}#{DIGITS[result("2#{op2}1")][0]}")

      assert_integer_result(expected, "3#{op1}2#{op2}1")
    end
  end

  def test_parens_precedence
    OPERATOR_PRECEDENCE.keys.product(OPERATOR_PRECEDENCE.keys).each do |op1, op2|
      expected = result("3#{op1}#{DIGITS[result("2#{op2}1")][0]}")

      assert_integer_result(expected, "3#{op1}(2#{op2}1)")
    end
  end

  def test_ignore_whitespace
    OPERATOR_PRECEDENCE.keys.each do |op|
      tokens = ["(", "(", "3", op, "2", ")", op, 1, ")"]
      expected = result(tokens.join)
      (1..3).map{|n| " \t\n"[0, n] }.each do |space|
        assert_integer_result(expected, space + tokens.join(space) + space)
      end
    end
  end

  def test_empty_parens
    (1..3).each do |nest|
      refute_parse("#{'(' * nest}#{')' * nest}")
    end
  end

  def test_missing_parens
    (0..3).to_a.product((1..3).to_a).each do |left, right|
      right = 0 if right == left
      refute_parse("#{'(' * left}42#{')' * right}")
    end
  end

  def test_missing_left_operand
    (OPERATOR_PRECEDENCE.keys - %w[+ -]).each do |op|
      refute_parse("#{op}42")
    end
  end

  def test_missing_right_operand
    OPERATOR_PRECEDENCE.keys.each do |op|
      refute_parse("42#{op}")
    end
  end


  protected

  def assert_integer_result(expected, input)
    assert_equal expected, result(input)
  end

  def assert_float_result(expected, input)
    if expected.nan?
      assert_predicate result(input), :nan?
    else
      assert_in_delta expected, result(input), 0.05
    end
  end

  def refute_parse(input)
    assert_raises(Parslet::ParseFailed) do
      result(input)
    end
  end

  def result(input)
    raise "override this method"
  end

end
