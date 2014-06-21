require 'llvm/core'
require 'llvm/execution_engine'
require 'llvm/transforms/scalar'
require 'parser'

LLVM.init_x86


module Calc

  class IntLiteral
    def emit(builder)
      LLVM::Int(val.to_i)
    end
  end


  class FloatLiteral
    def emit(builder)
      LLVM::Float(val.to_f)
    end
  end
  

  class OpSequence
    def emit(builder)
      left_float = left.float?
      
      rights.reduce(left.emit(builder)) do |left_emit, op_right|
        right_float = op_right.float?
        right_emit = op_right.right.emit(builder)
      
        if left_float || right_float
          left_emit = builder.si2fp(left_emit) unless left_float
          right_emit = builder.si2fp(right_emit) unless right_float
          left_float = true # for next iteration
        
          case op_right.op
            when '+'; builder.fadd(left_emit, right_emit)
            when '-'; builder.fsub(left_emit, right_emit)
            when '*'; builder.fmul(left_emit, right_emit)
            when '/'; builder.fdiv(left_emit, right_emit)
          end
        else
          case op_right.op
            when '+'; builder.add(left_emit, right_emit)
            when '-'; builder.sub(left_emit, right_emit)
            when '*'; builder.mul(left_emit, right_emit)
            when '/'; builder.sdiv(left_emit, right_emit)
          end
        end
      end
    end
  end


  def self.compile_run(src)
    src = parse(src) if src.is_a?(String)

    mod = LLVM::Module.new('Calc')
    as_float = src.float?

    mod.functions.add('calc', [], as_float ? LLVM::Float : LLVM::Int) do |f|
      f.basic_blocks.append('entry').build do |b|
        b.ret(src.emit(b))
      end
    end
    
    mod.verify
    #mod.dump

    jit = LLVM::JITCompiler.new(mod)
    result = jit.run_function(mod.functions['calc'])
    as_float ? result.to_f : result.to_i
  end

end
