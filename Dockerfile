FROM ubuntu:22.04

# 1. Update and upgrade, install only necessary packages with no extra recommends
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
      python3 python3-pip curl unzip openjdk-17-jre-headless nodejs npm && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# 2. Install Semgrep and SQLMap (Python tools)
RUN pip install --no-cache-dir semgrep sqlmap

# 3. Install Dependency-Check
RUN curl -LO https://github.com/dependency-check/DependencyCheck/releases/download/v12.1.0/dependency-check-12.1.0-release.zip && \
    unzip dependency-check-12.1.0-release.zip -d /opt && \
    mv /opt/dependency-check /opt/dependency-check-12.1.0 || true && \
    mv /opt/dependency-check-12.1.0 /opt/dependency-check && \
    ln -s /opt/dependency-check/bin/dependency-check.sh /usr/local/bin/dependency-check && \
    rm dependency-check-12.1.0-release.zip

# 4. Install CodeQL
RUN curl -LO https://github.com/github/codeql-cli-binaries/releases/download/v2.15.0/codeql-linux64.zip && \
    unzip codeql-linux64.zip -d /opt && rm codeql-linux64.zip
ENV PATH="/opt/codeql:/opt/dependency-check/bin:$PATH"

# 5. Install Trivy (container scanner)
RUN curl -LO https://github.com/aquasecurity/trivy/releases/download/v0.45.0/trivy_0.45.0_Linux-64bit.deb && \
    dpkg -i trivy_0.45.0_Linux-64bit.deb && rm trivy_0.45.0_Linux-64bit.deb

# 6. Install Docker CLI (for ZAP/Trivy integrations)
RUN curl -sSL https://get.docker.com/ | sh

# 7. Install OWASP ZAP (CLI and daemon)
RUN curl -LO https://github.com/zaproxy/zaproxy/releases/download/v2.16.1/ZAP_2.16.1_Linux.tar.gz && \
    mkdir -p /opt/zap && \
    tar -xzf ZAP_2.16.1_Linux.tar.gz -C /opt/zap --strip-components=1 && \
    rm ZAP_2.16.1_Linux.tar.gz

# 8. Copy scripts
COPY vibe-scan.sh generate-dashboard.js /usr/local/bin/
RUN chmod +x /usr/local/bin/vibe-scan.sh

ENTRYPOINT ["vibe-scan.sh"]