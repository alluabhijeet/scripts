# Start with Alpine Linux as the base image
FROM alpine:latest

# Set versions for Terraform and Vault
ARG TERRAFORM_VERSION=1.5.7
ARG VAULT_VERSION=1.14.1

# Install dependencies
RUN apk update && \
    apk add --no-cache \
        curl \
        unzip \
        bash \
        git \
        openssh-client

# Install Terraform
RUN curl -fsSL https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -o terraform.zip && \
    unzip terraform.zip && \
    mv terraform /usr/local/bin/ && \
    rm terraform.zip

# Install Vault
RUN curl -fsSL https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip -o vault.zip && \
    unzip vault.zip && \
    mv vault /usr/local/bin/ && \
    rm vault.zip

# Verify installations
RUN terraform -v && vault -v

# Add a non-root user (optional, for security)
RUN adduser -D jenkins
USER jenkins
WORKDIR /home/jenkins

# Set default shell for the user
SHELL ["/bin/bash", "-c"]

# Entrypoint for the Jenkins agent (optional if used as a Jenkins agent image)
ENTRYPOINT ["terraform"]
