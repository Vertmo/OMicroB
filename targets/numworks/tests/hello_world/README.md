# *Hello, world!* (and more tests) in OCaml, compiled to the Numworks

- See the `Makefile` for details about its compilation.
- See the `hello.ml` file for the code for the demo. It kinda gives a documentation for the different functions that are available in the Numworks library for OCaml that we wrote in OMicroB.

## Compiling the demo

If you have successfully configured OMicroB for the `numworks` target, and compiled it, then run the `make` command.

```bash
$ make
```

## Testing locally the demo

You can run the `hello.byte` binary, which does not use the OMicroB setup:

```bash
$ ./hello.byte
```

If everything works out well, then you can run the `hello.elf` binary, which does use the OMicroB setup:

```bash
$ ./hello.elf
```

## Testing the NWA app on a Numworks

Go to <https://my.numworks.com/apps> and install the `hello.nwa` app on your Numworks.
It should work fine when launched!

## A video showing that?

TODO: a video showing that!
