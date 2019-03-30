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
  
ENV KUBE_LATEST_VERSION="v1.14.0"

# Install kubectl

RUN apk add --update ca-certificates \
 && apk add --update -t deps curl \
 && curl -L https://storage.googleapis.com/kubernetes-release/release/${KUBE_LATEST_VERSION}/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl \
 && chmod +x /usr/local/bin/kubectl \
 && apk del --purge deps \
 && rm /var/cache/apk/*
