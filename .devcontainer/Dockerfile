FROM ruby:2.4

# Update apt sources for Debian Buster (EOL)
RUN sed -i 's|http://deb.debian.org/debian|http://archive.debian.org/debian|g' /etc/apt/sources.list && \
    sed -i 's|http://security.debian.org/debian-security|http://archive.debian.org/debian-security|g' /etc/apt/sources.list && \
    sed -i 's|http://deb.debian.org/debian buster-updates|http://archive.debian.org/debian buster-updates|g' /etc/apt/sources.list

# Set environment variables to avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Update package lists and install essential development tools, including PostgreSQL client, dev headers, locales, and nodejs for ExecJS
RUN apt-get update && apt-get install -y \
    postgresql-client \
    libpq-dev \
    nodejs \
    locales \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Generate and set locale
RUN localedef -i en_US -f UTF-8 en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Create vscode user
RUN useradd -m -s /bin/bash vscode

# Install Bundler 1.17.3
RUN gem install bundler -v 1.17.3

# Change ownership of gem directories
RUN chown -R vscode:vscode /usr/local/bundle

# Set working directory
USER vscode
WORKDIR /workspaces/iFarmPro
