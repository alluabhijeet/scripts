# Use Alpine Linux as the base image
FROM alpine:latest

# Set environment variables to avoid interactive prompts during package installation
ENV TERRAFORM_VERSION=1.5.0
ENV VAULT_VERSION=1.14.0

# Install dependencies
RUN apk update && \
    apk add --no-cache \
    curl \
    unzip \
    bash \
    jq \
    git

# Install Terraform
RUN curl -fsSL https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -o terraform.zip && \
    unzip terraform.zip && \
    mv terraform /usr/local/bin/ && \
    rm terraform.zip

# Install Vault CLI
RUN curl -fsSL https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip -o vault.zip && \
    unzip vault.zip && \
    mv vault /usr/local/bin/ && \
    rm vault.zip

# Set the working directory
WORKDIR /workspace

# Set the entrypoint to bash
ENTRYPOINT ["/bin/bash"]

# Expose ports for Vault (optional)
EXPOSE 8200

# Final message
CMD ["echo", "Terraform and Vault CLI installed successfully!"]
