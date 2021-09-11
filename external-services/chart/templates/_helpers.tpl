{{/*
Expand the name of the chart.
*/}}
{{- define "jet-external-services.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "jet-external-services.fullname" -}}
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
{{- define "jet-external-services.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "jet-external-services.labels" -}}
helm.sh/chart: {{ include "jet-external-services.chart" . }}
{{ include "jet-external-services.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "jet-external-services.selectorLabels" -}}
app.kubernetes.io/name: {{ include "jet-external-services.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/* Build the volume path for a container */}}
{{- define "jet-external-services.build-volume-path" -}}
{{- if empty .Values.volumesHostPath -}}
{{- fail "The volumesHostPath is required!" -}}
{{- else if .Values.volumesHostPath | isAbs | not -}}
{{- fail "An absolute volumesHostPath is required!" -}}
{{- else -}}
{{- printf "/%s/%s" .Values.volumesHostPath .storageName | clean -}}
{{- end -}}
{{- end -}}
