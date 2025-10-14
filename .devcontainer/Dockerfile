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
RUN apt-get update && apt-get install -y sudo \
    && useradd -m -s /bin/bash codespaces \
    && echo 'codespaces ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
    && mkdir -p /workspace \
    && chown -R codespaces:codespaces /workspace
USER codespaces
WORKDIR /workspace

# Set the default shell to bash

# Install rbenv and Ruby 2.4.2 for the codespaces user
USER root
RUN apt-get update && apt-get install -y \
    build-essential \
    libssl-dev \
    libreadline-dev \
    zlib1g-dev \
    git \
    && git clone https://github.com/rbenv/rbenv.git /home/codespaces/.rbenv \
    && cd /home/codespaces/.rbenv && src/configure && make -C src \
    && echo 'export PATH="/home/codespaces/.rbenv/bin:$PATH"' >> /home/codespaces/.bashrc \
    && echo 'eval "$(rbenv init -)"' >> /home/codespaces/.bashrc \
    && export PATH="/home/codespaces/.rbenv/bin:$PATH" \
    && git clone https://github.com/rbenv/ruby-build.git /home/codespaces/.rbenv/plugins/ruby-build \
    && chown -R codespaces:codespaces /home/codespaces/.rbenv \
    && su - codespaces -c '/home/codespaces/.rbenv/bin/rbenv install 2.4.2' \
    && su - codespaces -c '/home/codespaces/.rbenv/bin/rbenv global 2.4.2'
USER codespaces
CMD ["/bin/bash"]