# Use Ubuntu 20.04 as the base image
FROM ubuntu:20.04

# Set environment variables to avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive


# Update package lists and install essential development tools, including PostgreSQL client, dev headers, and locales
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    curl \
    vim \
    postgresql-client \
    libpq-dev \
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
    && mkdir -p /workspaces/iFarmPro \
    && chown -R codespaces:codespaces /workspaces/iFarmPro
USER codespaces
WORKDIR /workspaces/iFarmPro

# Set the default shell to bash

# Install rbenv
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
    && chown -R codespaces:codespaces /home/codespaces/.rbenv

# Install Ruby 2.4.2, Bundler 1.17.3, and project gems for the codespaces user
USER codespaces
RUN /home/codespaces/.rbenv/bin/rbenv install 2.4.2 \
    && /home/codespaces/.rbenv/bin/rbenv global 2.4.2 \
    && /home/codespaces/.rbenv/bin/rbenv exec gem install bundler -v 1.17.3

# # # Install gems
# # COPY --chown=codespaces:codespaces Gemfile Gemfile.lock /workspaces/iFarmPro/
# # RUN /home/codespaces/.rbenv/bin/rbenv exec bundle install

# CMD ["/bin/bash"]