#!/usr/bin/env make
SHELL := /bin/bash

repo := local
targets := targets/bookworm
versions := $(wildcard versions/*.env)

.PHONY: all
all:

$(targets): targets/%: %
	@true

%:
	@tgt=$@; for file in $(versions); do \
	    ver=$${file%.*}; \
	    source $${file}; \
	    docker buildx build . \
	        --file targets/$${tgt}/Dockerfile \
		--build-arg PYTHON_VERSION=$${ver##*/} \
		--tag $(repo)/python:$${PYTHON_RELEASE}-$${tgt} \
		--load \
	    || exit $${?}; \
	done
