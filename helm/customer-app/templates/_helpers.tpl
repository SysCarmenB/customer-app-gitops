{{- define "customer-app.fullname" -}}
{{- printf "%s-%s" .Release.Name .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "customer-app.labels" -}}
app: {{ include "customer-app.fullname" . }}
version: {{ .Chart.AppVersion | quote }}
managed-by: {{ .Release.Service }}
{{- end -}}
