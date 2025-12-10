{{/*
Helper template to load all config files from the configs/ directory.
This WORKS because the files are in the SAME chart as the template.
*/}}

{{- define "standalone-chart.loadConfigs" -}}
{{- $allConfigs := dict -}}

{{- /* Read all yaml files from configs/ directory */ -}}
{{- range $path, $content := .Files.Glob "configs/*.yaml" -}}
  {{- $filename := base $path -}}
  {{- $parsed := $content | toString | fromYaml -}}
  {{- if $parsed -}}
    {{- $allConfigs = merge $allConfigs $parsed -}}
  {{- end -}}
{{- end -}}

{{- /* Return merged configs */ -}}
{{- $allConfigs | toYaml -}}
{{- end -}}


{{/*
Helper to list all config files found
*/}}
{{- define "standalone-chart.listConfigFiles" -}}
{{- range $path, $_ := .Files.Glob "configs/*.yaml" }}
- {{ $path }}
{{- end }}
{{- end -}}
