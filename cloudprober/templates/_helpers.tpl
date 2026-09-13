{{/*
Expand the name of the chart.
*/}}
{{- define "cloudprober.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "cloudprober.fullname" -}}
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
{{- define "cloudprober.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "cloudprober.labels" -}}
helm.sh/chart: {{ include "cloudprober.chart" . }}
{{ include "cloudprober.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "cloudprober.selectorLabels" -}}
app.kubernetes.io/name: {{ include "cloudprober.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "cloudprober.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "cloudprober.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Retrieve configMap name from the name of the chart or the ConfigMap the user
specified.
*/}}
{{- define "cloudprober.config-map.name" -}}
{{- if .Values.configMap.name -}}
{{- .Values.configMap.name }}
{{- else -}}
{{- include "cloudprober.fullname" . }}
{{- end }}
{{- end }}

{{/*
Select which entry of .Values.service.ports serves the cloudprober status page
and metrics: the entry named "http" if there is one, otherwise the first entry.
Returns its index. Callers must only use this when .Values.service.ports is
set.
*/}}
{{- define "cloudprober.servicePortIndex" -}}
{{- $selected := 0 -}}
{{- range $i, $p := .Values.service.ports -}}
{{- if eq ($p.name | default "") "http" -}}
{{- $selected = $i -}}
{{- end -}}
{{- end -}}
{{- $selected -}}
{{- end -}}

{{/*
Retrieve the service port. .Values.service.ports takes precedence whenever it
is set; .Values.service.port is used otherwise.
*/}}
{{- define "cloudprober.servicePort" -}}
{{- if .Values.service.ports -}}
{{- $entry := index .Values.service.ports (include "cloudprober.servicePortIndex" . | atoi) -}}
{{- $entry.port -}}
{{- else -}}
{{- .Values.service.port -}}
{{- end -}}
{{- end -}}

{{/*
Retrieve the service port name, .Values.service.ports takes precedence whenever 
it is set; the name given to .Values.service.port is used otherwise.
*/}}
{{- define "cloudprober.servicePortName" -}}
{{- if .Values.service.ports -}}
{{- $entry := index .Values.service.ports (include "cloudprober.servicePortIndex" . | atoi) -}}
{{- $entry.name | default (printf "port-%v" $entry.port) -}}
{{- else -}}
{{- "http" -}}
{{- end -}}
{{- end }}
