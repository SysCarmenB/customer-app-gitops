{{- define "customer-api.fullname" -}}
{{- printf "%s-%s" .Release.Name .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "customer-api.labels" -}}
app: {{ include "customer-api.fullname" . }}
version: {{ .Chart.AppVersion | quote }}
managed-by: {{ .Release.Service }}
{{- end -}}
