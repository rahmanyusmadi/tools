FROM golang:alpine

RUN apk update && \
    apk add --update \
        git \
        bash \
        openssh \
        py-pip && \
    apk add --virtual=build \
        gcc \
        libffi-dev \
        musl-dev \
        openssl-dev \
        python-dev \
        make

# Build Terraform

ENV TERRAFORM_VERSION=0.11.13
ENV TF_DEV=true
ENV TF_RELEASE=true

WORKDIR $GOPATH/src/github.com/hashicorp/terraform
RUN git clone https://github.com/hashicorp/terraform.git ./ && \
    git checkout v${TERRAFORM_VERSION} && \
    /bin/bash scripts/build.sh

WORKDIR $GOPATH

# Install Azure CLI

RUN \
  pip install azure-cli && \
  apk del --purge build
  
