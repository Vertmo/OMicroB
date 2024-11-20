# [ViRoLam/Mini-Caml-Interpreter](https://github.com/ViRoLam/Mini-Caml-Interpreter) :tada: **running on a Numworks calculator**
> A tiny implementation of a small subset of a programming language like OCaml, written in OCaml. With small and fun examples.

## How to build the NWA Numworks app

First, you should `git clone` the [main project](https://github.com/Naereen/OMicroB/tree/numworks/) (my fork of `OMicroB`, branch `numworks`), having ran `make clean ; ./configure -target numworks ; make` to configure and compile `omicrob` for the Numworks...

Then, you can run, from this folder:
```bash
$ make
```
This should create the `minicaml.nwa` app, which you can then [install on your Numworks calculator](https://my.numworks.com/apps).

## It supports user defined programs
> By default, the app runs a short example, but you can define a file `minicaml.py` for the code of the program to be executed.
> There is no interactivity: the app *does not* let you chose which file should be executed, it always runs `minicaml.py` if present, or the default one otherwise.

See the files on [my user-space on Numworks.com](https://my.numworks.com/python/lilian-besson-1/):

- TODO: example about the Syracuse conjecture: <https://my.numworks.com/python/lilian-besson-1/minicaml-syracuse.py>


## More examples ?

- See [this folder](examples/).

---

### :scroll: License ? [![GitHub license](https://img.shields.io/github/license/Naereen/Tiny-Prolog-in-OCaml-OneFile.svg)](https://github.com/Naereen/Tiny-Prolog-in-OCaml-OneFile/blob/master/LICENSE)
This (small) folder is published under the terms of the [MIT license](http://lbesson.mit-license.org/) (file [LICENSE](LICENSE)).
© [Lilian Besson](https://GitHub.com/Naereen), 2024.

[![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg)](https://GitHub.com/Naereen/Tiny-Prolog-in-OCaml-OneFile/graphs/commit-activity)
[![Ask Me Anything !](https://img.shields.io/badge/Ask%20me-anything-1abc9c.svg)](https://GitHub.com/Naereen/Tiny-Prolog-in-OCaml)
[![Analytics](https://ga-beacon.appspot.com/UA-38514290-17/github.com/Naereen/Tiny-Prolog-in-OCaml-OneFile/README.md?pixel)](https://GitHub.com/Naereen/Tiny-Prolog-in-OCaml-OneFile/)

[![made-with-OCaml](https://img.shields.io/badge/Made%20with-OCaml-1f425f.svg)](https://ocaml.org/)
[![made-for-teaching](https://img.shields.io/badge/Made%20for-Teaching-6800ff.svg)](https://perso.crans.org/besson/teach/)

[![ForTheBadge built-with-science](http://ForTheBadge.com/images/badges/built-with-science.svg)](https://GitHub.com/Naereen/)
[![ForTheBadge uses-badges](http://ForTheBadge.com/images/badges/uses-badges.svg)](http://ForTheBadge.com)
[![ForTheBadge uses-git](http://ForTheBadge.com/images/badges/uses-git.svg)](https://GitHub.com/)
