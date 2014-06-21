$:<< File.join(File.dirname(__FILE__), '..', 'lib')
require 'compiler'
require 'rspec'

require 'test_cases'

  
describe 'Calc.compile_run' do
  TEST_CASES.each do |src, expected|
    it("#{src} == #{expected}") { 
      Calc.compile_run(src).should == expected
    }
  end
end
