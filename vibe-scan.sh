#!/bin/bash
# Vibe Security Scan Entrypoint Script
set -e

echo "[Vibe Security] Running Semgrep..."
semgrep --config=auto . || true

echo "[Vibe Security] Running SQLMap..."
# Example: scan all .sql files (customize as needed)
for f in $(find . -name '*.sql'); do
  sqlmap -u "file://$f" --batch || true
done

echo "[Vibe Security] Running Trivy..."
trivy fs . || true

echo "[Vibe Security] All scans complete."
