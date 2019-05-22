# re-use infra-core
FROM alpine:20190228

RUN apk update && \
    apk add --no-cache make jq python py-pip openssh-client unzip git gcc libffi-dev musl-dev openssl-dev python-dev curl bash python3 openssl docker sudo ca-certificates && \
	  curl -o /tmp/terraform.zip -L "https://releases.hashicorp.com/terraform/0.11.14/terraform_0.11.14_linux_amd64.zip" && \
    echo "9b9a4492738c69077b079e595f5b2a9ef1bc4e8fb5596610f69a6f322a8af8dd  /tmp/terraform.zip" > /tmp/terraform.sha256sum && \
    sha256sum -cs /tmp/terraform.sha256sum && \
    unzip /tmp/terraform.zip && \
    mv terraform /bin && \
    rm /tmp/terraform.* && \
	  rm -f /usr/bin/python && ln -s /usr/bin/python3 /usr/bin/python && \
	  pip install --upgrade pip && \
    pip install azure-cli  && \
    echo "jenkins ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    pip install --upgrade ansible openshift && \
    mkdir -p /var/lib/jenkins/.ansible/tmp && \
    mkdir -p /home/jenkins/.ansible/tmp && \
    chmod 777 -R /var/lib/jenkins/.ansible && \
    chmod 777 -R /home/jenkins/.ansible

ADD https://storage.googleapis.com/kubernetes-release/release/v1.6.4/bin/linux/amd64/kubectl /usr/local/bin/kubectl
RUN chmod +x /usr/local/bin/kubectl
