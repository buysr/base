#!/bin/bash
# Test script to demonstrate the PROBLEM

echo "========================================"
echo "DEMO: .Files.Glob Parent/Child Limitation"
echo "========================================"
echo ""
echo "This demonstrates that .Files.Glob CANNOT"
echo "read files from a subchart."
echo ""
echo "Running: helm template parent-chart/"
echo "----------------------------------------"

cd "$(dirname "$0")/parent-chart"

# Update dependencies first
helm dependency update . 2>/dev/null

# Run helm template
helm template .

echo ""
echo "----------------------------------------"
echo "Notice: The ConfigMap shows NO FILES FOUND"
echo "because .Files.Glob cannot access subchart files!"
echo "========================================"
