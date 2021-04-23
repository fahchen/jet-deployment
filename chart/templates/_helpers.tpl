{{/*
Expand the name of the chart.
*/}}
{{- define "jet-chart.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "jet-chart.fullname" -}}
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
{{- define "jet-chart.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "jet-chart.labels" -}}
helm.sh/chart: {{ include "jet-chart.chart" . }}
{{ include "jet-chart.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "jet-chart.selectorLabels" -}}
app.kubernetes.io/name: {{ include "jet-chart.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Return the proper Airbase image name
*/}}
{{- define "jet-chart.airbase-image" }}
{{- $registryName := .Values.airbase.image.registry -}}
{{- $repositoryName := .Values.airbase.image.repository -}}
{{- $tag := .Values.airbase.image.tag | toString -}}
{{- printf "%s/%s:%s" $registryName $repositoryName $tag -}}
{{- end }}

{{/*
Return the proper Aircrew image name
*/}}
{{- define "jet-chart.aircrew-image" }}
{{- $registryName := .Values.aircrew.image.registry -}}
{{- $repositoryName := .Values.aircrew.image.repository -}}
{{- $tag := .Values.aircrew.image.tag | toString -}}
{{- printf "%s/%s:%s" $registryName $repositoryName $tag -}}
{{- end }}

{{/*
Return the proper tls config for jet
*/}}
{{- define "jet-chart.jet-tls-options" }}
{{- if .Values.jetTLSSecret | empty | not }}
tls:
  secretName: {{ .Values.jetTLSSecret }}
{{- end }}
{{- end }}

{{/*
Return the proper tls config for minio
*/}}
{{- define "jet-chart.minio-tls-options" }}
{{- if .Values.minioTLSSecret | empty | not }}
tls:
  secretName: {{ .Values.minioTLSSecret }}
{{- end }}
{{- end }}

{{/*
Return the common middlewares for jet ingress-routes
*/}}
{{- define "jet-chart.jet-ingress-route-middlewares" }}
middlewares:
  - name: {{ include "jet-chart.fullname" . }}-compress
{{- if .Values.jetTLSSecret | empty | not }}
  - name: {{ include "jet-chart.fullname" . }}-redirect-to-https
{{- end }}
{{- end }}

{{/*
Return the common middlewares for minio ingress-routes
*/}}
{{- define "jet-chart.minio-ingress-route-middlewares" }}
middlewares:
  - name: {{ include "jet-chart.fullname" . }}-compress
{{- if .Values.minioTLSSecret | empty | not }}
  - name: {{ include "jet-chart.fullname" . }}-redirect-to-https
{{- end }}
{{- end }}
