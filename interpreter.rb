require './parser'


module Calc

  class IntLiteral
    def eval
      val.to_i
    end
  end


  class FloatLiteral
    def eval
      val.to_f
    end
  end


  class OpSequence
    def eval
      rights.reduce(left.eval) do |left_eval, op_right|
        right_eval = op_right.right.eval
        
        case op_right.op
          when '+'; left_eval + right_eval
          when '-'; left_eval - right_eval
          when '*'; left_eval * right_eval
          when '/'; left_eval / right_eval
        end
      end
    end
  end


  def self.interpret(src)
    src = parse(src) if src.is_a?(String)
    src.eval
  end

end
