$:<< File.join(File.dirname(__FILE__), '..', 'lib')
require 'compiler'
require 'rspec'

require 'examples'

  
describe 'Calc.compile_run' do
  EXAMPLES.each do |src, expected|
    it("#{src} == #{expected}") { 
      Calc.compile_run(src).should == expected
    }
  end
end
