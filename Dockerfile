FROM golang:alpine

# Build Terraform - https://hub.docker.com/r/hashicorp/terraform/dockerfile

ENV TERRAFORM_VERSION=0.11.13

RUN apk add --no-cache --update git bash openssh

ENV TF_DEV=true
ENV TF_RELEASE=true

WORKDIR $GOPATH/src/github.com/hashicorp/terraform
RUN git clone https://github.com/hashicorp/terraform.git ./ && \
    git checkout v${TERRAFORM_VERSION} && \
    /bin/bash scripts/build.sh

WORKDIR $GOPATH

# Install Azure CLI

RUN apk update \
 && apk add --no-cache --update \
        py-pip \
 && apk add --no-cache --virtual=terraform_dependencies \
        gcc \
        libffi-dev \
        musl-dev \
        openssl-dev \
        python-dev \
        make \
 && pip install azure-cli
  
# Install kubectl - https://github.com/lachie83/k8s-kubectl

# ENV KUBE_LATEST_VERSION="v1.14.0"

# RUN apk add --no-cache --update ca-certificates curl \
#  && apk add --no-cache --update --virtual=kubectl_dependencies \
#  && curl -L https://storage.googleapis.com/kubernetes-release/release/${KUBE_LATEST_VERSION}/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl \
#  && chmod +x /usr/local/bin/kubectl

RUN az aks install-cli

# Cleanup

RUN apk del --purge terraform_dependencies \
 && apk del --purge kubectl_dependencies \
 && rm /var/cache/apk/*
