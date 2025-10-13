# Use Ubuntu 20.04 as the base image
FROM ubuntu:20.04

# Set environment variables to avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Update package lists and install essential development tools, including PostgreSQL client and locales
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    curl \
    vim \
    postgresql-client \
    locales \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Generate and set locale
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8


# Create 'codespaces' user and ensure /workspace exists with correct ownership
RUN useradd -m -s /bin/bash codespaces && \
    mkdir -p /workspace && \
    chown -R codespaces:codespaces /workspace
USER codespaces
WORKDIR /workspace

# Set the default shell to bash
CMD ["/bin/bash"]