{{/*
Expand the name of the chart.
*/}}
{{- define "mysql.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "mysql.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "mysql.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "mysql.labels" -}}
helm.sh/chart: {{ include "mysql.chart" . }}
{{ include "mysql.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "mysql.databaseSecretName" -}}
{{- if .Values.auth.existingSecret -}}
  {{- printf "%s" .Values.auth.existingSecret -}}
{{- else -}}
  {{- printf "%s" (include "mysql.fullname" .) -}}
{{- end -}}
{{- end }}

{{/*
Create fully qualified database name
*/}}
{{- define "mysql.backupVolume" -}}
{{- printf "%s-backup" .Release.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "mysql.backupS3SecretName" -}}
{{- if .Values.backup.s3.existingSecret -}}
  {{- printf "%s" .Values.backup.s3.existingSecret -}}
{{- else -}}
  {{- printf "%s-backup-s3" (include "mysql.fullname" .) -}}
{{- end -}}
{{- end }}

{{- define "mysql.backupS3Prefix" -}}
{{- if .Values.backup.s3.prefix -}}
  {{- printf "%s/" .Values.backup.s3.prefix -}}
{{- else -}}
  {{- printf "" -}}
{{- end -}}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "mysql.selectorLabels" -}}
app.kubernetes.io/name: {{ include "mysql.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "mysql.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "mysql.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
