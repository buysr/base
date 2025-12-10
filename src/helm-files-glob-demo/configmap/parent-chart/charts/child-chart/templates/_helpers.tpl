{{/*
Child chart reads its OWN files and creates a ConfigMap.
The parent chart can then reference this ConfigMap.
*/}}

{{- define "child-chart.loadAllConfigs" -}}
{{- range $path, $content := .Files.Glob "configs/*.yaml" }}
{{ base $path }}: |
{{ $content | toString | indent 2 }}
{{- end -}}
{{- end -}}


{{- define "child-chart.mergedConfig" -}}
{{- $merged := dict -}}
{{- range $path, $content := .Files.Glob "configs/*.yaml" -}}
  {{- $parsed := $content | toString | fromYaml -}}
  {{- if $parsed -}}
    {{- $merged = merge $merged $parsed -}}
  {{- end -}}
{{- end -}}
{{- $merged | toYaml -}}
{{- end -}}
