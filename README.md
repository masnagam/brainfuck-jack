# A simple Brainf*ck interpreter written in Jack

## What's Brainf*ck

Brainf*ck is one of famous esoteric programming languages.  You can see the
details of this programming languages in the following pages:

* [Wikipedia](https://en.wikipedia.org/wiki/Brainfuck)
* [Esolang](https://esolangs.org/wiki/Brainfuck)

## How to run

Compile the source files by using a Jack compiler:

```shell
sh /path/to/tools/JackCompiler.sh .
```

Launch the VM Emulator:

```shell
sh /path/to/tools/VMEmulator.sh
```

Then open the folder containing the compiled VM files.

The tools can be downloaded from the official website of [nand2tetris] project.

If you want to execute another Brainf*ck source code, change values of the
following variables in `Main.jack`, and recompile the source files:

* `code`
* `interval`
* `numCells`

### For docker users

A docker user can execute the program by simply running `make`.  The `make`
command will build a Docker image named `$USER/nand2tetris`, compile Jack files
into VM files and then execute the VM Emulator in a container created from the
Docker image.

See `Makefile` for details.

## TODO

At this point, there is no convenient way to load a source code into a Jack
program.  Of course, Hack has a keyboard chip but it take a long time to
input a Brainf*ck source code manually without any mistake.  Above all, no one
want to do that.  That's the reason why we don't implement it at all.

No useful debug features like breakpoints have not been supported at this point.
But, we think that some of the debug features can be implemented with little
effort.

## License

Licensed under either of

* Apache License, Version 2.0
  ([LICENSE-APACHE] or http://www.apache.org/licenses/LICENSE-2.0)
* MIT License
  ([LICENSE-MIT] or http://opensource.org/licenses/MIT)

at your option.

Unless you explicitly state otherwise, any contribution intentionally submitted
for inclusion in this project by you, as defined in the Apache-2.0 license,
shall be dual licensed as above, without any additional terms or conditions.

[nand2tetris]: https://www.nand2tetris.org/
[LICENSE-APACHE]: ./LICENSE-APACHE
[LICENSE-MIT]: ./LICENSE-MIT
