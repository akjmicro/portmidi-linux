# BASED ON verbose monitoring of `cmake` output, the essential `gcc` commands are:
#/usr/bin/cc -DPMALSA -Dportmidi_EXPORTS -O3 -DNDEBUG -fPIC -pthread -o portmidi.o -c portmidi.c
#/usr/bin/cc -DPMALSA -Dportmidi_EXPORTS -O3 -DNDEBUG -fPIC -pthread -o pmutil.o -c pmutil.c
#/usr/bin/cc -DPMALSA -Dportmidi_EXPORTS -O3 -DNDEBUG -fPIC -pthread -o porttime.o -c porttime.c
#/usr/bin/cc -DPMALSA -Dportmidi_EXPORTS -O3 -DNDEBUG -fPIC -pthread -o ptlinux.o -c ptlinux.c
#/usr/bin/cc -DPMALSA -Dportmidi_EXPORTS -O3 -DNDEBUG -fPIC -pthread -o pmlinux.o -c pmlinux.c
#/usr/bin/cc -DPMALSA -Dportmidi_EXPORTS -O3 -DNDEBUG -fPIC -pthread -o pmlinuxnull.o -c pmlinuxnull.c
#/usr/bin/cc -DPMALSA -Dportmidi_EXPORTS -O3 -DNDEBUG -fPIC -pthread -o pmlinuxalsa.o -c pmlinuxalsa.c
#/usr/bin/cc -fPIC -O3 -DNDEBUG  -shared -Wl,-soname,libportmidi.so.2 -o libportmidi.so.2.0.4 \
#            portmidi.o pmutil.o porttime.o ptlinux.o pmlinux.o pmlinuxnull.o pmlinuxalsa.o \
#            /usr/lib/x86_64-linux-gnu/libasound.so -pthread
# /usr/bin/cmake -E cmake_symlink_library ../libportmidi.so.2.0.4 ../libportmidi.so.2 ../libportmidi.so
# From this, I was able to derive the following simple Makefile:

CC = gcc
CFLAGS = -DPMALSA -Dportmidi_EXPORTS -O3 -DNDEBUG -fPIC
SOFLAGS = -fPIC -O3 -DNDEBUG -shared -Wl,-soname,libportmidi.so.2
LDFLAGS = -lasound -pthread
OBJECTS = portmidi.o pmutil.o porttime.o ptlinux.c pmlinux.o pmlinuxnull.o pmlinuxalsa.o
LIBSOOBJ = libportmidi.so.2.0.4
LIBSOOBJ_SHORT = libportmidi.so.2
LIBSOOBJ_MINI = libportmidi.so
HEADERS = portmidi.h porttime.h
PREFIX ?= /usr/local

.PHONY: clean lib libtest

default: libportmidi.so.2.0.4

%.o: %.c
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ -c $<

libportmidi.so.2.0.4: $(OBJECTS)
	$(CC) $(SOFLAGS) -o $@ $(OBJECTS) $(LDFLAGS)

install: libportmidi.so.2.0.4
	sudo cp -a $(HEADERS) $(PREFIX)/include
	sudo cp -a $(LIBSOOBJ) $(PREFIX)/lib
	sudo ln -s $(PREFIX)/lib/$(LIBSOOBJ) $(PREFIX)/lib/$(LIBSOOBJ_SHORT)
	sudo ln -s $(PREFIX)/lib/$(LIBSOOBJ) $(PREFIX)/lib/$(LIBSOOBJ_MINI)
	sudo ldconfig

clean:
	rm -rf *.o *.so.* *.a
