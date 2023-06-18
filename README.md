## Portmidi (isolated simple Linux build)

Perhaps you've had a project where you wanted to simply build `Portmidi` for `linux`, just like I did.

Maybe you wanted a `docker` container that needed `portmidi`, perhaps a small container, but noticed that
the `busybox-gcc` containers didn't seem to have `cmake` in their package-manager target list,
which, unfortunately, `portmidi` officially depends on to build.

So, being crazy, you decide to bypass `cmake` and make a simple `Makefile` build of `portmidi` using clues
derived from what `cmake` actually does via the compiler by putting `cmake` into verbose-output mode.

Well, maybe this helps you, or maybe I'm the only fool needing this.

Either way, using this is simple:

```
make clean
make
sudo make install
```

By default, the `portmidi` library will end up in `/usr/local/lib`, and the headers in `/usr/local/include`.

You can change this by editing `PREFIX` in the `Makefile`.
