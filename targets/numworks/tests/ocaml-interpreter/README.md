# TODO: The OCaml interpreter, **running on a Numworks calculator**

## How to build the NWA Numworks app

First, you should `git clone` the [main project](https://github.com/stevenvar/OMicroB/tree/numworks/), checkout the branch `numworks`, having ran `make clean ; ./configure -target numworks ; make` to configure and compile `omicrob` for the Numworks.

Then, you can run, from this folder:
```bash
$ make
```
This should create the `ocaml-interpreter.nwa` app, which you can then [install on your Numworks calculator](https://my.numworks.com/apps).

## It should support user defined programs
> By default, the app runs a short example, but you can define a file `ocaml.py` for the code of the program to be executed.
> There is no interactivity: the app *does not* let you chose which file should be executed, it always runs `ocaml.py` if present, or the default one otherwise.

See the files on [my user-space on Numworks.com](https://my.numworks.com/python/lilian-besson-1/):

- TODO: example about the Syracuse conjecture: <https://my.numworks.com/python/lilian-besson-1/minicaml-syracuse.py>

## TODO: More examples ?

- See [this folder](examples/).
