# Makefile for x86-64 GAS assembly projects

AS = as
LD = ld
ASFLAGS = --64 -g
LDFLAGS = -m elf_x86_64

# All .s files in this directory
SOURCES = $(wildcard *.s)
OBJECTS = $(SOURCES:.s=.o)
TARGETS = $(SOURCES:.s=)

.PHONY: all clean run

all: $(TARGETS)

# Pattern rule: .s -> .o -> executable
%: %.s
	$(AS) $(ASFLAGS) -o $@.o $<
	$(LD) $(LDFLAGS) -o $@ $@.o

# Run the hello program
run: hello
	./hello

clean:
	rm -f $(OBJECTS) $(TARGETS)

# Debug: disassemble
disasm: hello
	objdump -d hello
