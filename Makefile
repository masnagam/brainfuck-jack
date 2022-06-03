# Command to execute in a devenv container.
DISPLAY ?= :0

IMAGE := $(shell id -un)/nand2tetris
PROJ := /proj
COMPILER := /nand2tetris/tools/JackCompiler.sh
VMEMULATOR := /nand2tetris/tools/VMEmulator.sh

ifeq ($(filter $(shell id -nG),docker),docker)
DOCKER := docker
else
DOCKER := sudo docker
endif

JACK_FILES := $(wildcard Brainfuck/*.jack)
VM_FILES := $(JACK_FILES:%.jack=%.vm)

RUN_OPTIONS := \
  --network=host \
  -e DISPLAY \
  -e XAUTHORITY=/tmp/.Xauthority \
  -v $(XAUTHORITY):/tmp/.Xauthority

.PHONY: all
all: run

.PHONY: image
image: image.timestamp

# Just launch VMEmulator.
# You need to manually select /proj in the container in order to execute the program after the launch.
.PHONY: run
run: vm
	@$(DOCKER) run --rm --init -v $(shell pwd):$(PROJ) $(RUN_OPTIONS) $(IMAGE) sh $(VMEMULATOR)

.PHONY: vm
vm: $(VM_FILES)

.PHONY: clean
clean:
	@rm -f $(VM_FILES)

.PHONY: cleanall
cleanall: clean
	@if [ -n "$$($(DOCKER) image ls -q $(IMAGE))" ]; then \
	  $(DOCKER) image rm -f $(IMAGE) >/dev/null; \
	fi
	@rm -f image.timestamp

image.timestamp: Dockerfile docker/setup.sh docker/entrypoint.sh
	@$(DOCKER) build -t $(IMAGE) .
	@touch $@

%.vm: %.jack image.timestamp
	@$(DOCKER) run --rm --init -v $(shell pwd):$(PROJ) $(IMAGE) sh $(COMPILER) $<
