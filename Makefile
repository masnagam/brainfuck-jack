# Parameters for the run target
DISPLAY ?= :0

# Parameters for the transfer target
INTERVAL ?= 100
NUM_CELLS ?= 32
PROGRAM ?=

# Constants

IMAGE := $(shell id -un)/nand2tetris
PROJ := /proj
COMPILER := /nand2tetris/tools/JackCompiler.sh
VMEMULATOR := /nand2tetris/tools/VMEmulator.sh
CONTAINER_NAME := brainfuck

ifeq ($(filter $(shell id -nG),docker),docker)
DOCKER := docker
else
DOCKER := sudo docker
endif

JACK_FILES := $(wildcard Brainfuck/*.jack)
VM_FILES := $(JACK_FILES:%.jack=%.vm)

RUN_OPTIONS := \
  --name=$(CONTAINER_NAME) \
  --network=host \
  -e DISPLAY=$(DISPLAY) \
  -e XAUTHORITY=/tmp/.Xauthority \
  -v $(XAUTHORITY):/tmp/.Xauthority

# Targets

.PHONY: all
all: run

# Just launch the VM Emulator.
# You need to manually select the /proj/Brainfuck folder in the container in
# order to execute the interpreter after the launch.
.PHONY: run
run: vm
	@$(DOCKER) run -d --rm --init -v $(shell pwd):$(PROJ) $(RUN_OPTIONS) $(IMAGE) sh $(VMEMULATOR)

.PHONY: vm
vm: $(VM_FILES)

.PHONY: stop
stop:
	@$(DOCKER) kill $(CONTAINER_NAME)

# Usage:
# make transfer INTERVAL=0 NUM_CELLS=16 PROGRAM=examples/shortest_hello_world.bf
.PHONY: transfer
transfer:
	@$(DOCKER) exec -it $(CONTAINER_NAME) sh /transfer.sh -i $(INTERVAL) -n $(NUM_CELLS) $(PROGRAM)

.PHONY: image
image: image.timestamp

.PHONY: clean
clean:
	@rm -f $(VM_FILES)

.PHONY: cleanall
cleanall: clean
	@if [ -n "$$($(DOCKER) image ls -q $(IMAGE))" ]; then \
	  $(DOCKER) image rm -f $(IMAGE) >/dev/null; \
	fi
	@rm -f image.timestamp

image.timestamp: Dockerfile docker/setup.sh docker/entrypoint.sh docker/transfer.sh
	@$(DOCKER) build -t $(IMAGE) .
	@touch $@

%.vm: %.jack image.timestamp
	@$(DOCKER) run --rm --init -v $(shell pwd):$(PROJ) $(IMAGE) sh $(COMPILER) $<
