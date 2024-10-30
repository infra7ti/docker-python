#!/usr/bin/env make

repo := local
target := bookworm
versions := $(wildcard versions/*.env)

all: target/${target}
.PHONY: all

target/%:
	@tgt=$@; for file in $(versions); do \
	    ver=$${file%.*}; \
	    source $${file}; \
	    echo docker buildx build \
	        --file targets/$${tgt}/Dockerfile \
		--build-arg PYTHON_VERSION=$${ver} \
		--tag $(repo)/python:$${PYTHON_RELEASE}-$${tgt} \
	    || exit $${?}; \
	done
