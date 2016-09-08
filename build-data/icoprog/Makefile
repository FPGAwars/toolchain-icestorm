CC = arm-linux-gnueabihf-gcc

LDLIBS = -lwiringPi -lrt -lstdc++ -lpthread
CCFLAGS = -Wall -Os
LDFLAGS = -static -L $(PWD)/wiringPi/ -I $(PWD)/wiringPi/

all: icoprog

icoprog: icoprog.cc
	$(CC) -o $@ $(LDFLAGS) $^ $(LDLIBS)

clean:
	rm -f icoprog

.PHONY: all clean
