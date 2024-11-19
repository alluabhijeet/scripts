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
---
variable "applications" {
  type = list(object({
    name            = string
    dashboard_owner = string
    services = list(object({
      name                               = string
      availability_slo_target           = float
      availability_slo_warning          = float
      availability_slo_evaluation_window = string
      latency_slo_target                = float
      latency_slo_warning               = float
      latency_slo_evaluation_window     = string
      service_latency                   = number
      slo_burn_rate_alert_threshold     = number
      tags                               = list(object({
        key   = string
        value = string
      }))
    }))
  }))
  description = "A list of applications with their associated services and configurations"
}
---
applications:
  - name: Trading
    dashboard_owner: abhijeet.allu.official@gmail.com
    services:
      - name: Account-Service
        availability_slo_target: 99.9
        availability_slo_warning: 99.99
        availability_slo_evaluation_window: -30d
        latency_slo_target: 90
        latency_slo_warning: 95
        latency_slo_evaluation_window: -30d
        service_latency: 200
        slo_burn_rate_alert_threshold : 1
        tags:
          - key: "[Kubernetes]app"
            value: accountservice
      - name: Login-Service
        availability_slo_target: 99.8
        availability_slo_warning: 99.95
        availability_slo_evaluation_window: -30d
        latency_slo_target: 85
        latency_slo_warning: 90
        latency_slo_evaluation_window: -30d
        service_latency: 250
        slo_burn_rate_alert_threshold : 1
        tags:
          - key: "[Kubernetes]app"
            value: loginservice
---

# dynatrace-oneagent-clusterrole.yaml
kind: ClusterRole
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: dynatrace-oneagent-metadata-viewer
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["get"]

---

kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: dynatrace-oneagent-metadata-viewer-binding
subjects:
- kind: ServiceAccount
  name: default
  namespace: namespace1 # Specify the namespace of the service account
roleRef:
  kind: ClusterRole
  name: dynatrace-oneagent-metadata-viewer
  apiGroup: rbac.authorization.k8s.io
