# Vibe Security Docker

[![Publish to GHCR](https://img.shields.io/badge/GHCR-vibe--security-blue?logo=github)](https://github.com/vibe-security/vibe-docker/pkgs/container/vibe-security)


A prebuilt Docker image for running Vibe Security scans with zero local dependencies. Ideal for CI/CD and isolated environments.

## Features

📚 **Full documentation:** [Vibe Security Suite Docs – Docker](https://vibe-security.github.io/vibe-security-suite/docs/docker)

- All tools pre-installed (Semgrep, SQLMap, Trivy, etc.)
- No need to install anything on your host
- Consistent results across platforms

## Usage
```sh
docker run -v $(pwd):/app ghcr.io/vibe-security/vibe-docker:latest
```

## License
MIT
