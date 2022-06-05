# A simple Brainfuck interpreter written in Jack

## What's Brainfuck

Brainfuck is one of famous esoteric programming languages.  You can see the
details of this programming languages in the following pages:

* [Wikipedia](https://en.wikipedia.org/wiki/Brainfuck)
* [Esolang](https://esolangs.org/wiki/Brainfuck)

## How to run

Compile the source files by using a Jack compiler:

```shell
sh /path/to/tools/JackCompiler.sh Brainfuck
```

Launch the VM Emulator:

```shell
sh /path/to/tools/VMEmulator.sh
```

Then open the `Brainfuck` folder containing the compiled VM files.

After starting the interpreter, you have to input the following parameters on
the VM Emulator using the keyboard:

* Interval
* The number of cells to allocate
* A Brainfuck program

For convenient, we provides a helper script named `scripts/transfer.sh`:

```shell
# `sh scripts/transfer.sh -h` displays the usage.
sh scripts/transfer.sh
```

The tools can be downloaded from the official website of [nand2tetris] project.

### For docker users

A docker user can execute the program by simply running `make`.  The `make`
command will build a Docker image named `$USER/nand2tetris`, compile Jack files
into VM files and then execute the VM Emulator in a container created from the
Docker image.

After starting the interpreter, run the following command on a terminal running
on the Docker host machine:

```shell
make transfer INTERVAL=0 NUM_CELLS=16 PROGRAM=examples/shortest_hello_world.bf
```

See `Makefile` for details.

## TODO

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
