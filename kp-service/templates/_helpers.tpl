{{/*
Release name: {name}-{environment}, max 63 chars for DNS compatibility
*/}}
{{- define "kp-service.fullname" -}}
{{- printf "%s-%s" .Values.name .Values.environment | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Chart label: name-version
*/}}
{{- define "kp-service.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels applied to all resources
*/}}
{{- define "kp-service.labels" -}}
helm.sh/chart: {{ include "kp-service.chart" . }}
{{ include "kp-service.selectorLabels" . }}
app.kubernetes.io/version: {{ .Values.image.tag | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/environment: {{ .Values.environment }}
app.kubernetes.io/team: {{ .Values.team }}
{{- end }}

{{/*
Selector labels — must be stable across upgrades (used in matchLabels)
*/}}
{{- define "kp-service.selectorLabels" -}}
app.kubernetes.io/name: {{ .Values.name }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Service account name: explicit override or derived from {name}-{environment}
*/}}
{{- define "kp-service.serviceAccountName" -}}
{{- if .Values.serviceAccountName -}}
{{- .Values.serviceAccountName -}}
{{- else if .Values.serviceAccount.create -}}
{{- printf "%s-%s" .Values.name .Values.environment | trimSuffix "-" -}}
{{- else -}}
default
{{- end -}}
{{- end }}

{{/*
Full image reference including tag
*/}}
{{- define "kp-service.image" -}}
{{- printf "%s:%s" .Values.image.repository .Values.image.tag }}
{{- end }}
