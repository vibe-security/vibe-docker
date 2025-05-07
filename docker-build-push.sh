#!/bin/bash
set -e

# Load .env if present
if [ -f .env ]; then
  set -a
  source .env
  set +a
fi

# Usage: ./docker-build-push.sh <dockerhub-username> <dockerhub-token> <image-name>
# Example: ./docker-build-push.sh sha888 mytoken vibe-security-tool

DOCKERHUB_USERNAME="${1:-$DOCKERHUB_USERNAME}"
DOCKERHUB_TOKEN="${2:-$DOCKERHUB_TOKEN}"
IMAGE_NAME="${3:-vibe-security-tool}"

# Use latest git tag as version, fallback to 'latest' if none
VERSION=$(git describe --tags --abbrev=0 2>/dev/null || echo latest)

if [[ -z "$DOCKERHUB_USERNAME" || -z "$DOCKERHUB_TOKEN" ]]; then
  echo "Usage: $0 <dockerhub-username> <dockerhub-token> <image-name>"
  echo "Or set DOCKERHUB_USERNAME and DOCKERHUB_TOKEN as environment variables or in .env file."
  exit 1
fi

echo "Using version: $VERSION"
echo "Logging into Docker Hub..."
echo "$DOCKERHUB_TOKEN" | docker login -u "$DOCKERHUB_USERNAME" --password-stdin

echo "Building Docker image..."
docker build -t "$DOCKERHUB_USERNAME/$IMAGE_NAME:latest" -t "$DOCKERHUB_USERNAME/$IMAGE_NAME:$VERSION" .

echo "Pushing Docker image with tags: latest and $VERSION"
docker push "$DOCKERHUB_USERNAME/$IMAGE_NAME:latest"
docker push "$DOCKERHUB_USERNAME/$IMAGE_NAME:$VERSION"

echo "Docker image pushed successfully!"
