{{/*
Expand the name of the chart.
*/}}
{{- define "tigase-xmpp-server.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "tigase-xmpp-server.fullname" -}}
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
Create a default fully qualified app name for LDAP server.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "tigase-xmpp-server.ldap.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s-ldap" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "tigase-xmpp-server.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "tigase-xmpp-server.labels" -}}
helm.sh/chart: {{ include "tigase-xmpp-server.chart" . }}
{{ include "tigase-xmpp-server.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "tigase-xmpp-server.selectorLabels" -}}
app.kubernetes.io/name: {{ include "tigase-xmpp-server.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "tigase-xmpp-server.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "tigase-xmpp-server.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "tigase.vhost" }}
{{- .Values.vhost }}
{{- end }}

{{- define "tigase.databaseType" }}
{{- .Values.database.type }}
{{- end }}

{{- define "tigase.databaseHost" }}
{{- .Values.database.host }}
{{- end }}

{{- define "tigase.databasePort" }}
{{- if .Values.database.port }}
{{- .Values.database.port }}
{{- else }}
{{- if eq .Values.database.type "mysql" }}
{{- printf "3306" }}
{{- else if eq .Values.database.type "postgresql" }}
{{- printf "5432" }}
{{- end }}
{{- end }}
{{- end }}

{{- define "tigase.databaseName" }}
{{- .Values.database.name }}
{{- end }}

{{- define "tigase.databaseUser" }}
{{- .Values.database.user }}
{{- end }}

{{- define "tigase.databaseSecretName" }}
{{- printf "%s" .Values.database.secret -}}
{{- end }}