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
and metrics: the entry named "http" if there is one, otherwise the entry targeting
the http container port, and fail otherwise.
Returns its index. Callers must only use this when .Values.service.ports is set.
*/}}
{{- define "cloudprober.servicePortIndex" -}}
{{- $byName := -1 -}}
{{- $byTarget := -1 -}}
{{- range $i, $p := .Values.service.ports -}}
{{- if and (lt $byName 0) (eq ($p.name | default "") "http") -}}
{{- $byName = $i -}}
{{- end -}}
{{- if and (lt $byTarget 0) (has (toString ($p.targetPort | default $p.port)) (list "http" "9313")) -}}
{{- $byTarget = $i -}}
{{- end -}}
{{- end -}}
{{- if ge $byName 0 -}}{{ $byName }}
{{- else if ge $byTarget 0 -}}{{ $byTarget }}
{{- else -}}{{ fail "service.ports must include an entry named \"http\" or targeting the http container port (9313)" }}
{{- end -}}
{{- end -}}

{{/*
Name of a single .Values.service.ports entry: its explicit name, or one
derived from the port and protocol. Takes the port entry as context.
*/}}
{{- define "cloudprober.servicePortEntryName" -}}
{{- .name | default (printf "port-%v-%s" .port (.protocol | default "TCP" | lower)) -}}
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
{{- include "cloudprober.servicePortEntryName" $entry -}}
{{- else -}}
{{- "http" -}}
{{- end -}}
{{- end }}
