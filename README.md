# Calc

A calculator domain-specific language with both an interpreter and a
compiler.  Implemented in Ruby using [Parslet][] for parsing and [LLVM][]
for JIT compilation.

  [parslet]: http://kschiess.github.io/parslet/
  [llvm]: http://llvm.org/


## Installation

First, install LLVM 3.5 from source (this requires Python 2):

```bash
$ wget -qO- http://llvm.org/releases/3.5.2/llvm-3.5.2.src.tar.xz | tar -xJ

$ cd llvm-3.5.2.src

$ ./configure --enable-shared --enable-jit --prefix=/usr/lib/llvm-3.5

# This will take a while...
$ make

$ sudo make install
```

Next, run `bundle install` with a pointer to LLVM:

```bash
$ cd /path/to/calc

$ LLVM_CONFIG=/usr/lib/llvm-3.5/bin/llvm-config bundle install
```

Finally, run the tests:

```bash
$ LD_LIBRARY_PATH=/usr/lib/llvm-3.5/lib bundle exec rake test
```


## Usage

Start the REPL in interpreter mode:

```bash
$ LD_LIBRARY_PATH=/usr/lib/llvm-3.5/lib bundle exec rake repl
```

Or in JIT mode:

```bash
$ LD_LIBRARY_PATH=/usr/lib/llvm-3.5/lib bundle exec rake repl[jit]
```

Then try a few examples:

```
> 1 + 1
2

> 22.0 / 7
3.142857142857143

> 2 * (5 - 2) * (5 + 2)
42
```

Exit the REPL with <kbd>CTRL+D</kbd>.
