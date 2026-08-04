{{- define "turbo-webhook-handler.fullname" -}}
{{- printf "%s-%s" .Release.Name .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "turbo-webhook-handler.labels" -}}
app: {{ include "turbo-webhook-handler.fullname" . }}
version: {{ .Chart.AppVersion | quote }}
managed-by: {{ .Release.Service }}
{{- end -}}
