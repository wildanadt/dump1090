#
# When building a package or installing otherwise in the system, make
# sure that the variable PREFIX is defined, e.g. make PREFIX=/usr/local
#
PROGNAME=dump1090

ifdef PREFIX
BINDIR=$(PREFIX)/bin
SHAREDIR=$(PREFIX)/share/$(PROGNAME)
EXTRACFLAGS=-DHTMLPATH=\"$(SHAREDIR)\"
endif

CFLAGS+=-O2 -g -Wall -Werror -W `pkg-config --cflags librtlsdr`
LIBS=-lpthread -lm -lrt
LIBS_RTL=`pkg-config --libs librtlsdr`
CC=gcc


all: dump1090 view1090

%.o: %.c dump1090.h
	$(CC) $(CPPFLAGS) $(CFLAGS) $(EXTRACFLAGS) -c $< -o $@

dump1090: dump1090.o anet.o interactive.o mode_ac.o mode_s.o net_io.o crc.o demod_2000.o demod_2400.o stats.o cpr.o
	$(CC) -g -o $@ $^ $(LIBS) $(LIBS_RTL) $(LDFLAGS)

view1090: view1090.o anet.o interactive.o mode_ac.o mode_s.o net_io.o crc.o stats.o cpr.o
	$(CC) -g -o $@ $^ $(LIBS) $(LDFLAGS)

clean:
	rm -f *.o dump1090 view1090 cprtests

test: cprtests
	$(PWD)/cprtests

cprtests: cpr.o cprtests.o
	$(CC) -g -o $@ $^ $(LIBS) $(LDFLAGS)
