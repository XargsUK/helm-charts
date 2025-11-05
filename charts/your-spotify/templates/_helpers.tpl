{{/*
Expand the name of the chart.
*/}}
{{- define "your-spotify.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "your-spotify.fullname" -}}
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
{{- define "your-spotify.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "your-spotify.labels" -}}
helm.sh/chart: {{ include "your-spotify.chart" . }}
{{ include "your-spotify.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "your-spotify.selectorLabels" -}}
app.kubernetes.io/name: {{ include "your-spotify.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Server labels
*/}}
{{- define "your-spotify.server.labels" -}}
helm.sh/chart: {{ include "your-spotify.chart" . }}
{{ include "your-spotify.server.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/component: server
{{- end }}

{{/*
Server selector labels
*/}}
{{- define "your-spotify.server.selectorLabels" -}}
app.kubernetes.io/name: {{ include "your-spotify.name" . }}-server
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: server
{{- end }}

{{/*
Client labels
*/}}
{{- define "your-spotify.client.labels" -}}
helm.sh/chart: {{ include "your-spotify.chart" . }}
{{ include "your-spotify.client.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/component: client
{{- end }}

{{/*
Client selector labels
*/}}
{{- define "your-spotify.client.selectorLabels" -}}
app.kubernetes.io/name: {{ include "your-spotify.name" . }}-client
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: client
{{- end }}

{{/*
MongoDB labels
*/}}
{{- define "your-spotify.mongodb.labels" -}}
helm.sh/chart: {{ include "your-spotify.chart" . }}
{{ include "your-spotify.mongodb.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/component: mongodb
{{- end }}

{{/*
MongoDB selector labels
*/}}
{{- define "your-spotify.mongodb.selectorLabels" -}}
app.kubernetes.io/name: {{ include "your-spotify.name" . }}-mongodb
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: mongodb
{{- end }}

{{/*
Get the secret name
*/}}
{{- define "your-spotify.secretName" -}}
{{- if .Values.secrets.existingSecret }}
{{- .Values.secrets.existingSecret }}
{{- else }}
{{- include "your-spotify.fullname" . }}-secret
{{- end }}
{{- end }}

{{/*
Get the MongoDB connection string
*/}}
{{- define "your-spotify.mongoEndpoint" -}}
{{- if .Values.config.mongoEndpoint }}
{{- tpl .Values.config.mongoEndpoint . }}
{{- else }}
{{- printf "mongodb://%s-mongodb:27017/your_spotify" (include "your-spotify.fullname" .) }}
{{- end }}
{{- end }}
