require "test_helper"
require "interpreter"

class InterpreterTest < Minitest::Test

  include CalcTest

  protected

  def result(input)
    Calc.interpret(input)
  end

end
