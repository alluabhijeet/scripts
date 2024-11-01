# Start with Fedora as the base image
FROM fedora:latest

# Set versions for Terraform and Vault
ARG TERRAFORM_VERSION=1.5.7
ARG VAULT_VERSION=1.14.1

# Install dependencies
RUN dnf update -y && \
    dnf install -y \
        curl \
        unzip \
        git \
        openssh-clients \
        bash && \
    dnf clean all

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
RUN useradd -ms /bin/bash jenkins
USER jenkins
WORKDIR /home/jenkins

# Set default shell for the user
SHELL ["/bin/bash", "-c"]

# Entrypoint for the Jenkins agent (optional if used as a Jenkins agent image)
ENTRYPOINT ["terraform"]
---
pipeline {
    agent {
        dockerfile {
            filename 'Dockerfile' // Path to the Dockerfile
            dir '.'              // Directory where the Dockerfile is located
        }
    }

    stages {
        stage('Verify Terraform') {
            steps {
                // Run terraform version to check if it's installed and working
                sh 'terraform version'
            }
        }
    }

    post {
        success {
            echo 'Terraform is installed and working!'
        }
        failure {
            echo 'Failed to verify Terraform installation.'
        }
    }
}
