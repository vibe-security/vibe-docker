# Vibe Security Docker

A prebuilt Docker image for running Vibe Security scans with zero local dependencies. Ideal for CI/CD and isolated environments.

## Features
- All tools pre-installed (Semgrep, SQLMap, Trivy, etc.)
- No need to install anything on your host
- Consistent results across platforms

## Usage
```sh
docker run -v $(pwd):/app vibe-security/vibe-docker:latest
```

## License
MIT
