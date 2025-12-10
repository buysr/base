# 🔍 Why can't my Parent Chart read Subcharts files?

## A Deep Dive into Helm's `.Files.Glob` Limitation

Ever tried to use `.Files.Glob` from your parent chart to read configuration files stored in a subchart? Maybe you expected the parent to simply access files in `charts/my-subchart/configs/*.yaml` — but instead, you got... nothing. You're not alone! This is one of Helm's most confusing behaviors for newcomers.

## The Problem

Helm's `.Files.Glob` function can **only read files from within the same chart**.
This means a parent chart CANNOT read files that exist in a subchart.

This is **by design** - see the [Helm documentation](https://helm.sh/docs/chart_template_guide/accessing_files/).

## Demo Structure

```
helm-files-glob-demo/
├── README.md
├── run-demo.sh                 # Runs all 3 demos
│
├── problem/                    # Demonstrates the PROBLEM
│   ├── parent-chart/           # Parent chart tries to read subchart files
│   │   ├── Chart.yaml
│   │   ├── templates/
│   │   │   └── configmap.yaml  # Tries .Files.Glob on subchart (FAILS!)
│   │   └── charts/
│   │       └── child-chart/    # Subchart with config files
│   │           ├── Chart.yaml
│   │           ├── configs/
│   │           │   ├── database.yaml
│   │           │   └── cache.yaml
│   │           └── templates/
│   │               └── _helpers.tpl
│   └── test.sh
│
├── standalone/                 # SOLUTION: Standalone chart
│   ├── Chart.yaml              # No dependencies
│   ├── configs/                # Config files in same chart
│   │   ├── database.yaml
│   │   ├── cache.yaml
│   │   └── networking.yaml
│   ├── templates/
│   │   ├── _helpers.tpl
│   │   └── configmap.yaml      # .Files.Glob works here!
│   ├── values.yaml
│   └── test.sh
│
└── configmap/                  # ALTERNATIVE: Subchart creates ConfigMap
    ├── parent-chart/           # Parent references subchart's ConfigMap
    │   ├── Chart.yaml
    │   ├── templates/
    │   │   └── deployment.yaml # Mounts ConfigMap from subchart
    │   └── charts/
    │       └── child-chart/    # Subchart creates its own ConfigMap
    │           ├── Chart.yaml
    │           ├── configs/
    │           ├── templates/
    │           │   ├── _helpers.tpl
    │           │   └── configmap.yaml  # Subchart reads its own files
    └── test.sh
```

## Quick Tests

### Test 1: The Problem (FAILS)
```bash
cd problem/parent-chart
helm dependency update .
helm template .
# Result: Empty output - .Files.Glob finds NO files in subchart
```

### Test 2: The Solution - Standalone Chart (WORKS)
```bash
cd standalone
helm template .
# Result: All config files are correctly loaded
```

### Test 3: Alternative - ConfigMap Approach (WORKS at runtime)
```bash
cd configmap/parent-chart
helm dependency update .
helm template .
# Result: Subchart creates ConfigMap, parent can mount it
```

## Why doesn't .Files.Glob work across charts?

1. Helm compiles each chart **independently**
2. The `.Files` object only contains files from the **current** chart
3. Subcharts are separate charts with their own `.Files` scope
4. There is no way to reference subchart files from a parent chart

## Solutions

### Option A: Standalone Chart (Recommended)
Make the chart standalone without dependencies. Files are directly in the chart.
**Use case:** When you need file contents during Helm template rendering.

→ Demonstrated in the `standalone/` folder.

### Option B: ConfigMap from Subchart
The subchart creates a ConfigMap with its file contents. Parent mounts that ConfigMap.
**Use case:** When you only need the data at runtime (in containers).

→ Demonstrated in the `configmap/` folder.

### Option C: Values.yaml
Put all configuration in values.yaml instead of separate files.
**Use case:** When configuration is simple and doesn't need file structure.

## Running the Demo

### Prerequisites

Make sure you have Helm installed. See the [official Helm installation guide](https://helm.sh/docs/intro/install/) for instructions.

### Execute the Scripts

```bash
# Run all demos
./run-demo.sh

# Or individually:
./problem/test.sh      # Shows the problem
./standalone/test.sh   # Shows standalone solution  
./configmap/test.sh    # Shows ConfigMap alternative
```

## Important Note

The **ConfigMap approach** only works for **runtime** data access. If you need file contents
during Helm template rendering (e.g., to generate Kubernetes resources based on file contents),
you **must use the standalone chart approach**.
