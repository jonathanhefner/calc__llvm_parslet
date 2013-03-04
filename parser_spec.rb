require './interpreter'
require 'rspec'
require 'parslet/rig/rspec'


describe CalcParser do
  subject(:parser) { described_class.new }
  
  describe '#int' do
    subject { parser.int }
    
    it { should parse('123') }
    it { should parse('+123') }
    it { should parse('-123') }
    
    it { should_not parse('1.23') }
    it { should_not parse('+1.23') }
    it { should_not parse('-1.23') }
  end
  
  
  describe '#float' do
    subject { parser.float }
    
    it { should parse('1.23') }
    it { should parse('+1.23') }
    it { should parse('-1.23') }
    
    it { should_not parse('123') }
    it { should_not parse('+123') }
    it { should_not parse('-123') }
  end
  
  
  context 'binary operators' do
    it { should parse('1+1') }
    it { should parse('1-1') }
    it { should parse('1*1') }
    it { should parse('1/1') }
    it { should parse('1+1-1*1/1') }
    
    it { should_not parse('1+') }
    it { should_not parse('1+1+') }
  end
  
  
  context 'parenthesis' do
    it { should parse('(1+1)') }
    it { should parse('(1+(1+1))') }
    
    it { should_not parse('()') }
    it { should_not parse('(1+())') }
  end
  
  
  context 'whitespace' do
    it { should parse('  1  +  1  ') }
    it { should parse('  (  1  +  1  )  ') }
    it { should parse('  (  1  +  ( 1 +  1 )  )  ') }
  end
  
end
