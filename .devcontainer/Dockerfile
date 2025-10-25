# Use Microsoft devcontainer base image for Ubuntu 22.04
FROM mcr.microsoft.com/devcontainers/base:ubuntu-22.04

# Set environment variables to avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive


# Update package lists and install essential development tools, including PostgreSQL client, dev headers, locales, and nodejs for ExecJS
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    curl \
    vim \
    postgresql-client \
    libpq-dev \
    locales \
    nodejs \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install PhantomJS for Capybara Poltergeist
# RUN apt-get update && apt-get install -y phantomjs xvfb && rm -rf /var/lib/apt/lists/*

# Generate and set locale
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8


# Create (or reuse) 'vscode' user and ensure /workspace exists with correct ownership
RUN apt-get update && apt-get install -y sudo \
    && if ! id -u vscode >/dev/null 2>&1; then useradd -m -s /bin/bash vscode; fi \
    && echo 'vscode ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
    && mkdir -p /workspaces/iFarmPro \
    && chown -R vscode:vscode /workspaces/iFarmPro
USER vscode
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
    && git clone https://github.com/rbenv/rbenv.git /home/vscode/.rbenv \
    && cd /home/vscode/.rbenv && src/configure && make -C src \
    && echo 'export PATH="/home/vscode/.rbenv/bin:$PATH"' >> /home/vscode/.bashrc \
    && echo 'eval "$(rbenv init -)"' >> /home/vscode/.bashrc \
    && export PATH="/home/vscode/.rbenv/bin:$PATH" \
    && git clone https://github.com/rbenv/ruby-build.git /home/vscode/.rbenv/plugins/ruby-build \
    && chown -R vscode:vscode /home/vscode/.rbenv

# Install Ruby 2.4.2, Bundler 1.17.3, and project gems for the codespaces user
USER vscode
RUN /home/vscode/.rbenv/bin/rbenv install 2.4.2 \
    && /home/vscode/.rbenv/bin/rbenv global 2.4.2 \
    && /home/vscode/.rbenv/bin/rbenv exec gem install bundler -v 1.17.3

# # # Install gems
# # COPY --chown=vscode:vscode Gemfile Gemfile.lock /workspaces/iFarmPro/
# # RUN /home/vscode/.rbenv/bin/rbenv exec bundle install

# CMD ["/bin/bash"]