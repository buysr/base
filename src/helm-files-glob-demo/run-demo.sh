#!/bin/bash
# Master test script - runs both demos

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "╔══════════════════════════════════════════════════════════════╗"
echo "║  Helm .Files.Glob Demo: Parent/Child Chart Limitation        ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""
echo "This demo shows WHY .Files.Glob cannot read files from subcharts"
echo "and HOW to solve it with a standalone chart approach."
echo ""

# Make test scripts executable
chmod +x "$SCRIPT_DIR/problem/test.sh"
chmod +x "$SCRIPT_DIR/standalone/test.sh"
chmod +x "$SCRIPT_DIR/configmap/test.sh"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "PART 1: THE PROBLEM"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
bash "$SCRIPT_DIR/problem/test.sh"

echo ""
echo ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "PART 2: THE SOLUTION (Standalone Chart)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
bash "$SCRIPT_DIR/standalone/test.sh"

echo ""
echo ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "PART 3: ALTERNATIVE (Subchart creates ConfigMap)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
bash "$SCRIPT_DIR/configmap/test.sh"

echo ""
echo ""
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║  CONCLUSION                                                   ║"
echo "╠══════════════════════════════════════════════════════════════╣"
echo "║  • .Files.Glob only sees files in the CURRENT chart          ║"
echo "║  • Parent charts CANNOT read subchart files                   ║"
echo "║                                                               ║"
echo "║  Solutions:                                                   ║"
echo "║  1. Standalone chart with own templates (recommended)        ║"
echo "║  2. Subchart creates ConfigMap, parent references it         ║"
echo "╚══════════════════════════════════════════════════════════════╝"
