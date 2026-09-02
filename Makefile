SHELL := /bin/sh

.PHONY: all help build smoke demo-asm clean image shell source check-program check-tool run inspect gdb demo-intro valgrind container-smoke

PROGRAM ?=
ARGS ?=
FILE ?=
PAGER ?= less

all: build

help:
	@echo 'CSCI 3160 in-class examples'
	@echo '  make build                              Build all examples'
	@echo '  make shell                              Enter the Docker environment'
	@echo '  make run PROGRAM=name [ARGS="..."]      Run an example'
	@echo '  make inspect PROGRAM=name               Show source and disassembly'
	@echo '  make gdb PROGRAM=name [ARGS="..."]      Debug an example'
	@echo '  make demo-asm                            Build the first machine-code demo artifacts'
	@echo '  make demo-intro                         Run the first CS:APP source-to-machine-code demo'
	@echo '  make valgrind PROGRAM=name [ARGS="..."] Profile an example'
	@echo '  make source FILE=examples/path/file.c   Read source in a pager'
	@echo '  make smoke                              Run automated smoke tests'

build:
	./scripts/build.sh

smoke: build
	./scripts/smoke.sh
	./scripts/asm-demo-smoke.sh

demo-asm:
	./scripts/asm-demo.sh

clean:
	rm -rf build

image:
	docker build $(if $(DOCKER_PLATFORM),--platform $(DOCKER_PLATFORM),) --tag csci-3160-inclass:local .

shell: image
	docker run --rm --interactive --tty \
		$(if $(DOCKER_PLATFORM),--platform $(DOCKER_PLATFORM),) \
		--cap-add=SYS_PTRACE --security-opt seccomp=unconfined \
		--volume "$(CURDIR):/workspace/inclass" \
		--workdir /workspace/inclass \
		csci-3160-inclass:local bash

source:
	@test -n "$(FILE)" || (echo 'Usage: make source FILE=examples/path/example.c' >&2; exit 2)
	$(PAGER) "$(FILE)"

check-program:
	@test -n "$(PROGRAM)" || (echo 'Usage: make PROGRAM=name <target>' >&2; exit 2)
	@test -x "build/bin/$(PROGRAM)" || (echo "Unknown or unbuilt program: $(PROGRAM) (run make build first)" >&2; exit 2)

check-tool:
	@command -v "$(TOOL)" >/dev/null 2>&1 || (echo "$(TOOL) is not installed; run make shell for the course environment" >&2; exit 2)

run: check-program
	build/bin/$(PROGRAM) $(ARGS)

inspect: TOOL=objdump
inspect: check-program check-tool
	objdump -d -S build/bin/$(PROGRAM)

gdb: TOOL=gdb
gdb: check-program check-tool
	gdb --args build/bin/$(PROGRAM) $(ARGS)

demo-intro:
	./scripts/intro-demo.sh

valgrind: TOOL=valgrind
valgrind: check-program check-tool
	valgrind --leak-check=full --track-origins=yes build/bin/$(PROGRAM) $(ARGS)

container-smoke: image
	docker run --rm $(if $(DOCKER_PLATFORM),--platform $(DOCKER_PLATFORM),) \
		--workdir /workspace/inclass \
		csci-3160-inclass:local make smoke
