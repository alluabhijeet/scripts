# Use Fedora as the base image
FROM fedora:latest

# Install required dependencies for Terraform and Vault
RUN dnf -y update && dnf -y install \
    curl \
    unzip \
    gnupg \
    lsb-release \
    && dnf clean all

# Install Terraform
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | tee /etc/apt/trusted.gpg.d/hashicorp.asc
RUN echo "deb https://apt.releases.hashicorp.com fedora stable" | tee /etc/yum.repos.d/hashicorp.repo
RUN dnf -y install terraform

# Install Vault CLI
RUN curl -fsSL https://releases.hashicorp.com/vault/1.15.0/vault_1.15.0_linux_amd64.zip -o /tmp/vault.zip
RUN unzip /tmp/vault.zip -d /usr/local/bin/ && rm /tmp/vault.zip

# Expose Vault's default port (not really necessary here as we're not running Vault)
EXPOSE 8200

# Set environment variables (if needed)
ENV VAULT_ADDR=http://127.0.0.1:8200

# Set default command (Terraform CLI for interactive use)
CMD ["bash"]
