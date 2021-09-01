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
{{- $registryName := .Values.imageCredentials.registry -}}
{{- $repositoryName := .Values.airbase.image.repository -}}
{{- $tag := .Values.airbase.image.tag | toString -}}
{{- printf "%s/%s:%s" $registryName $repositoryName $tag -}}
{{- end }}

{{/*
Return the proper Aircrew image name
*/}}
{{- define "jet-chart.aircrew-image" }}
{{- $registryName := .Values.imageCredentials.registry -}}
{{- $repositoryName := .Values.aircrew.image.repository -}}
{{- $tag := .Values.aircrew.image.tag | toString -}}
{{- printf "%s/%s:%s" $registryName $repositoryName $tag -}}
{{- end }}

{{/* Build clean path.(//jet -> /jet) */}}
{{- define "jet-chart.build-path" }}
{{- $subpath := default "/" .Values.jetSubpath -}}
{{- printf "/%s/%s" $subpath .path | clean -}}
{{- end }}
