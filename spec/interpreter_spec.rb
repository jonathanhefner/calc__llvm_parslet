$:<< File.join(File.dirname(__FILE__), '..', 'lib')
require 'interpreter'
require 'rspec'

require 'examples'

  
describe 'Calc.interpret' do
  EXAMPLES.each do |src, expected|
    it("#{src} == #{expected}") { 
      Calc.interpret(src).should == expected
    }
  end
end
