#!/bin/bash
# Test script to demonstrate the SOLUTION

echo "========================================"
echo "DEMO: Standalone Chart with .Files.Glob"
echo "========================================"
echo ""
echo "This demonstrates that .Files.Glob WORKS"
echo "when files are in the SAME chart."
echo ""
echo "Running: helm template ."
echo "----------------------------------------"

cd "$(dirname "$0")"

# Run helm template
helm template .

echo ""
echo "----------------------------------------"
echo "Notice: The ConfigMap contains ALL config files!"
echo "This works because files are in the same chart."
echo "========================================"
