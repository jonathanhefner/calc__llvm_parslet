require "rake"
require "test_helper"


class ReplTest < Minitest::Test

  def test_repl
    assert_repl_result(/1337/, "13*100+37\n")
  end

  def test_repl_rescues_parse_error
    assert_repl_result(/ERROR:/, "bad\n")
  end

  def test_repl_rescues_math_error
    # JIT has undefined behavior for "1/0" (i.e. returns arbitrary i32)
    assert_repl_result(/(ERROR:)?/, "1/0\n")
  end

  private

  def assert_repl_result(output, input)
    [nil, "jit"].each do |jit|
      Rake.application = Rake::Application.new
      Rake.application.init
      Rake.application.load_rakefile

      $stdin = StringIO.new(input)
      assert_output(output) do
        Rake.application[:repl].invoke(jit)
      end
    end
  end

end
