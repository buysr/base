{{/*
Child chart helper - this CAN read its own files
But parent chart cannot call this template and get the files!
*/}}
{{- define "child-chart.loadConfigs" -}}
{{- range $path, $content := .Files.Glob "configs/*.yaml" }}
{{ base $path }}:
{{ $content | indent 2 }}
{{- end }}
{{- end -}}
