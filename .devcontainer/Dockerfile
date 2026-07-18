FROM mcr.microsoft.com/devcontainers/base:bookworm

# Versions (override at build time with --build-arg)
ARG TERRAFORM_VERSION=1.10.0
ARG TFLINT_VERSION=0.53.0
# TARGETARCH is auto-populated by BuildKit with the real target arch
# (amd64 / arm64) — do NOT give it a default, or the wrong arch gets used.
ARG TARGETARCH
ARG TFSEC_VERSION=1.28.11

ENV DEBIAN_FRONTEND=noninteractive

# Base packages + Python + tooling
RUN apt-get update && apt-get install -y --no-install-recommends \
        python3 \
        python3-pip \
        python3-venv \
        unzip \
        curl \
        ca-certificates \
        gnupg \
    && ln -sf /usr/bin/python3 /usr/local/bin/python \
    && rm -rf /var/lib/apt/lists/*

# AWS CLI v2
RUN case "${TARGETARCH}" in \
        amd64) AWS_ARCH=x86_64 ;; \
        arm64) AWS_ARCH=aarch64 ;; \
        *) AWS_ARCH=x86_64 ;; \
    esac \
    && curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-${AWS_ARCH}.zip" -o /tmp/awscliv2.zip \
    && unzip -q /tmp/awscliv2.zip -d /tmp \
    && /tmp/aws/install \
    && rm -rf /tmp/awscliv2.zip /tmp/aws

# Terraform
RUN curl -fsSL "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_${TARGETARCH}.zip" -o /tmp/terraform.zip \
    && unzip -q /tmp/terraform.zip -d /usr/local/bin \
    && chmod +x /usr/local/bin/terraform \
    && rm -f /tmp/terraform.zip

# TFLint (Terraform lint)
RUN curl -fsSL "https://github.com/terraform-linters/tflint/releases/download/v${TFLINT_VERSION}/tflint_linux_${TARGETARCH}.zip" -o /tmp/tflint.zip \
    && unzip -q /tmp/tflint.zip -d /usr/local/bin \
    && chmod +x /usr/local/bin/tflint \
    && rm -f /tmp/tflint.zip

# tfsec (Terraform security scanner)
RUN curl -fsSL "https://github.com/aquasecurity/tfsec/releases/download/v${TFSEC_VERSION}/tfsec-linux-${TARGETARCH}" -o /usr/local/bin/tfsec \
    && chmod +x /usr/local/bin/tfsec

# Node.js (runtime for Claude Code)
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y --no-install-recommends nodejs \
    && rm -rf /var/lib/apt/lists/*

ENV DEBIAN_FRONTEND=dialog

# --- vscode user setup ---
USER vscode

# Git config
RUN git config --global user.name "kalyanchandramohan" \
    && git config --global user.email "kalyanchandramohan@gmail.com" \
    && git config --global init.defaultBranch main

# Claude Code CLI
RUN curl -fsSL https://claude.ai/install.sh | bash
ENV PATH="/home/vscode/.local/bin:${PATH}"
