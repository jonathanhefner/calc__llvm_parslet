$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require "rake/testtask"


desc "Launch (a crude) REPL"
task :repl, [:jit] do |t, args|
  require (args[:jit] ? "compiler" : "interpreter")
  loop do
    $stdout.print "> "
    input = $stdin.gets or break
    begin
      result = args[:jit] ? Calc.compile_run(input) : Calc.interpret(input)
      $stdout.puts result, "\n"
    rescue StandardError => e
      $stdout.puts "ERROR: #{e}", "\n"
    end
  end
end


Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/*_test.rb"]
end


task :default => :test
