$:<< File.join(File.dirname(__FILE__), '..', 'lib')
require 'interpreter'
require 'rspec'

require 'test_cases'

  
describe 'Calc.interpret' do
  TEST_CASES.each do |src, expected|
    it("#{src} == #{expected}") { 
      Calc.interpret(src).should == expected
    }
  end
end
