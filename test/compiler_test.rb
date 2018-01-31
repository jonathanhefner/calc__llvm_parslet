require "test_helper"
require "compiler"

class CompilerTest < Minitest::Test

  include CalcTest

  protected

  def result(input)
    Calc.compile_run(input)
  end

end
