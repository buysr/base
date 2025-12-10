#!/bin/bash
# Test script for the ConfigMap ALTERNATIVE solution

echo "========================================"
echo "DEMO: Alternative - Subchart ConfigMap"
echo "========================================"
echo ""
echo "This demonstrates the ALTERNATIVE approach:"
echo "The subchart creates a ConfigMap with its files,"
echo "and the parent chart references that ConfigMap."
echo ""
echo "Running: helm template parent-chart/"
echo "----------------------------------------"

cd "$(dirname "$0")/parent-chart"

# Update dependencies
helm dependency update . 2>/dev/null

# Run helm template
helm template .

echo ""
echo "----------------------------------------"
echo "Notice:"
echo "1. child-chart-configs ConfigMap is created BY the subchart"
echo "2. Parent's Deployment MOUNTS that ConfigMap"
echo "3. Data flows: files -> subchart -> ConfigMap -> parent"
echo ""
echo "LIMITATION: This only works for RUNTIME access!"
echo "If you need data during Helm template rendering,"
echo "use the standalone chart approach instead."
echo "========================================"
