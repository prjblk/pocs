# Use an official Ubuntu as a parent image
FROM ubuntu:20.04

# Set the maintainer label (optional)
LABEL maintainer="your-email@example.com"

# Set the DEBIAN_FRONTEND environment variable to avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    gnupg \
    lsb-release \
    sudo \
    iproute2 \
    apache2 \
    unzip \
    nano \
    git \
    bash \
    net-tools \
    php7.4 \
    php7.4-cli \
    php7.4-fpm \
    php7.4-mysql \
    php7.4-xml \
    php7.4-mbstring \
    php7.4-curl \
    php7.4-json \
    php7.4-gd \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install ZendTo
RUN wget https://zend.to/files/ZendTo-6.10-4.tgz -O /tmp/zendto.tgz \
    && tar xzf /tmp/zendto.tgz -C /opt \
    && mv /opt/ZendTo-6.10-4 /opt/zendto \
    && rm /tmp/zendto.tgz

# Install ZendTo dependencies (if any)
RUN apt-get update && \
    wget https://zend.to/files/zendto_6.10-4.deb -O /tmp/zendto.deb && \
    dpkg -i /tmp/zendto.deb || apt-get install -f -y && \
    rm /tmp/zendto.deb

# Install ZendTo installation package
RUN wget -O /tmp/install.ZendTo.tgz https://zend.to/files/install.ZendTo.tgz \
    && tar xzf /tmp/install.ZendTo.tgz -C /opt \
    && /opt/install.ZendTo/install.sh \
    && rm /tmp/install.ZendTo.tgz

# Expose port 443 (SSL)
EXPOSE 443

# Set up default environment variables (optional)
ENV ZENDTO_HOME=/opt/zendto

# Start Apache, PHP-FPM, and keep the container running
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
