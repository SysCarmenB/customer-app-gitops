{{- define "load-generator.fullname" -}}
{{- printf "%s-%s" .Release.Name .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "load-generator.labels" -}}
app: {{ include "load-generator.fullname" . }}
version: {{ .Chart.AppVersion | quote }}
managed-by: {{ .Release.Service }}
{{- end -}}
