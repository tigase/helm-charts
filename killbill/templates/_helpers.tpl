{{/*
Expand the name of the chart.
*/}}
{{- define "killbill.name" -}}
{{- default .Chart.Name .Values.killbill.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "kaui.name" -}}
{{- default "kaui" .Values.kaui.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "inventory-checker-service-name" -}}
{{ .Values.sidecar.name }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "killbill.fullname" -}}
{{- if .Values.killbill.fullnameOverride }}
{{- .Values.killbill.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.killbill.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{- define "kaui.fullname" -}}
{{- if .Values.kaui.fullnameOverride }}
{{- .Values.kaui.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default "kaui" .Values.kaui.nameOverride }}
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
{{- define "killbill.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "kaui.chart" -}}
{{- printf "kaui-%s" .Values.kaui.image.tag | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "killbill.labels" -}}
helm.sh/chart: {{ include "killbill.chart" . }}
{{ include "killbill.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "kaui.labels" -}}
helm.sh/chart: {{ include "kaui.chart" . }}
{{ include "kaui.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Values.kaui.image.tag | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "killbill.selectorLabels" -}}
app.kubernetes.io/name: {{ include "killbill.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "kaui.selectorLabels" -}}
app.kubernetes.io/name: {{ include "kaui.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/**/}}
{{/*Create the name of the service account to use*/}}
{{/**/}}
{{/*{{- define "killbill.serviceAccountName" -}}*/}}
{{/*{{- if .Values.serviceAccount.create }}*/}}
{{/*{{- default (include "killbill.fullname" .) .Values.serviceAccount.name }}*/}}
{{/*{{- else }}*/}}
{{/*{{- default "default" .Values.serviceAccount.name }}*/}}
{{/*{{- end }}*/}}
{{/*{{- end }}*/}}

{{- define "killbill.databaseHost" -}}
  {{- printf "%s" .Values.database.host -}}
{{- end -}}

{{- define "killbill.databasePort" -}}
  {{- printf "%d" (.Values.database.port | int ) -}}
{{- end -}}

{{- define "killbill.databaseName" -}}
{{- printf "%s" .Values.database.killbill -}}
{{- end -}}

{{- define "killbill.databaseSecretName" -}}
  {{- printf "%s" .Values.database.existingSecret -}}
{{- end -}}

{{- define "kaui.databaseName" -}}
{{- printf "%s" .Values.database.kaui -}}
{{- end -}}

{{- define "killbill.databaseUrl" -}}
  {{- printf "jdbc:mysql://%s:%s/%s?allowPublicKeyRetrieval=true" (include "killbill.databaseHost" .) (include "killbill.databasePort" .) (include "killbill.databaseName" .) -}}
{{- end -}}

{{- define "kaui.databaseUrl" -}}
  {{- printf "jdbc:mysql://%s:%s/%s?allowPublicKeyRetrieval=true" (include "killbill.databaseHost" .) (include "killbill.databasePort" .) (include "kaui.databaseName" .) -}}
{{- end -}}

{{- define "killbill.url" -}}
{{- if .Values.ingress.enabled -}}
{{- if .Values.ingress.tls }}
  {{- printf "https://%s" (index .Values.ingress.hosts 0).host -}}
{{- else -}}
  {{- printf "http://%s" (index .Values.ingress.hosts 0).host -}}
{{- end -}}
{{- else -}}
  {{- printf "http://%s:%d" (index .Values.ingress.hosts 0).host .Values.killbill.service.port -}}
{{- end -}}
{{- end -}}

{{- define "killbill.internalUrl" -}}
  {{- printf "http://%s:%d" (include "killbill.fullname" .) (.Values.killbill.service.port | int) -}}
{{- end -}}
