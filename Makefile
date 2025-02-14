REGISTRY ?= quay.io
IMAGE_NAMESPACE ?= mavazque
IMAGE_NAME ?= fakefish
IMAGE_URL ?= $(REGISTRY)/$(IMAGE_NAMESPACE)/$(IMAGE_NAME)
TAG ?= latest

.PHONY: build-supermicro build-custom pre-reqs

default: pre-reqs build-custom

build-samba-supermicro:
	podman build . -f samba_supermicro_scripts/Containerfile -t ${IMAGE_URL}:${TAG}
	podman build . -f samba_pod/Containerfile -t samba

build-custom: pre-reqs
	podman build . -f custom_scripts/Containerfile -t ${IMAGE_URL}:${TAG}

.SILENT:
pre-reqs:
	if [ $(shell find custom_scripts/ -name "*.sh" | grep -Ec "mountcd.sh|poweroff.sh|poweron.sh|unmountcd.sh|bootfromcdonce.sh") -ne 5 ];then echo 'Missing custom scripts or bad naming';exit 1;fi
