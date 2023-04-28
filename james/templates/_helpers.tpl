{{/*
Expand the name of the chart.
*/}}
{{- define "james.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "james.fullname" -}}
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
{{- define "james.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "james.labels" -}}
helm.sh/chart: {{ include "james.chart" . }}
{{ include "james.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "james.selectorLabels" -}}
app.kubernetes.io/name: {{ include "james.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "james.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "james.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}


{{- define "james.databaseHost" -}}
  {{- printf "%s" .Values.database.host -}}
{{- end -}}

{{- define "james.databaseName" -}}
{{- printf "%s" .Values.database.name -}}
{{- end -}}

{{- define "james.databaseUsername" -}}
  {{- printf "%s" .Values.database.username -}}
{{- end -}}
{{- define "james.databasePassword" -}}
  {{- printf "%s" .Values.database.password -}}
{{- end -}}

{{- define "james.tigaseHost" -}}
  {{- printf "%s" .Values.tigase.host -}}
{{- end -}}

{{- define "james.tigasePort" -}}
  {{- printf "%s" .Values.tigase.port -}}
{{- end -}}

{{- define "james.tigaseAdminUsername" -}}
  {{- printf "%s" .Values.tigase.admin.username -}}
{{- end -}}

{{- define "james.tigaseAdminPassword" -}}
  {{- printf "%s" .Values.tigase.admin.password -}}
{{- end -}}

{{- define "james.RemoteDelivery.gateway" -}}
  {{- printf "%s" .Values.mailet.remoteDelivery.gateway -}}
{{- end -}}

{{- define "james.RemoteDelivery.gatewayPort" -}}
  {{- printf "%s" .Values.mailet.remoteDelivery.gatewayPort -}}
{{- end -}}

{{- define "james.RemoteDelivery.gatewayUsername" -}}
  {{- printf "%s" .Values.mailet.remoteDelivery.gatewayUsername -}}
{{- end -}}

{{- define "james.RemoteDelivery.gatewayPassword" -}}
  {{- printf "%s" .Values.mailet.remoteDelivery.gatewayPassword -}}
{{- end -}}

