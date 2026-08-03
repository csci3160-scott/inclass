SHELL := /bin/sh

.PHONY: all build smoke clean image container-smoke

all: build

build:
	./scripts/build.sh

smoke: build
	./scripts/smoke.sh

clean:
	rm -rf build

image:
	docker build $(if $(DOCKER_PLATFORM),--platform $(DOCKER_PLATFORM),) --tag csci-3160-inclass:local .

container-smoke: image
	docker run --rm $(if $(DOCKER_PLATFORM),--platform $(DOCKER_PLATFORM),) \
		--volume "$(CURDIR):/workspace/inclass" \
		--workdir /workspace/inclass \
		csci-3160-inclass:local make smoke
