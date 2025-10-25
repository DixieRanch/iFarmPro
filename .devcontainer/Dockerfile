# Use Microsoft devcontainer base image for Ubuntu 22.04
FROM mcr.microsoft.com/devcontainers/base:ubuntu-22.04

# Set environment variables to avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive


# Update package lists and install essential development tools, including PostgreSQL client, dev headers, locales, and nodejs for ExecJS
RUN apt-get update && apt-get install -y \
    postgresql-client \
    libpq-dev \
    nodejs \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Generate and set locale
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8


# Install rbenv
RUN git clone https://github.com/rbenv/rbenv.git /home/vscode/.rbenv \
    && cd /home/vscode/.rbenv && src/configure && make -C src \
    && echo 'export PATH="/home/vscode/.rbenv/bin:$PATH"' >> /home/vscode/.bashrc \
    && echo 'eval "$(rbenv init -)"' >> /home/vscode/.bashrc \
    && export PATH="/home/vscode/.rbenv/bin:$PATH" \
    && git clone https://github.com/rbenv/ruby-build.git /home/vscode/.rbenv/plugins/ruby-build \
    && chown -R vscode:vscode /home/vscode/.rbenv

# Set working directory
USER vscode
WORKDIR /workspaces/iFarmPro

# Install Ruby 2.4.2, Bundler 1.17.3, and project gems for the codespaces user
RUN /home/vscode/.rbenv/bin/rbenv install 2.4.2 \
    && /home/vscode/.rbenv/bin/rbenv global 2.4.2 \
    && /home/vscode/.rbenv/bin/rbenv exec gem install bundler -v 1.17.3
