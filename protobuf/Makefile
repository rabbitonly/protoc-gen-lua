SRC=pb.c

TARGET=pb.so
CFLAGS=-I../include -std=gnu99
LDFLAGS=-L../lib -llua

all:$(TARGET)

$(TARGET):$(SRC)
	gcc -O3 -shared -fPIC $(SRC) $(CFLAGS) $(LDFLAGS) -o $@
