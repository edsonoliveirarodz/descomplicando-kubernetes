{{/*
Criar as nossas tags
*/}}
{{- define "app.labels" -}}
app: {{ .labels.app | quote }}
env: {{ .labels.env | quote }}
live: {{ .labels.live | quote }}
{{- end }}

{{/*
Definir os limites de recursos
*/}}
{{- define "app.resources" -}}
requests:
  cpu: {{ .resources.requests.cpu }}
  memory: {{ .resources.requests.memory }}
limits:
  cpu: {{ .resources.limits.cpu }}
  memory: {{ .resources.limits.memory }}
{{- end }}

{{/*
Definir as portas dos containers
*/}}
{{- define "app.ports" -}}
{{ range .ports }}
- containerPort: {{ .port }}
{{- end }}
{{- end }}

{{/*
Definindo os nossos configmaps
*/}}
{{- define "databases.configmap" -}}
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ .component }}-db-config
data:
  app-config.yaml: |
    {{- toYaml .config | nindent 4 }}
{{- end }}

{{/*
Definindo os nossos configmaps
*/}}
{{- define "observability.configmap" -}}
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ .component }}-observability-config
data:
  app-config.json: |
    {{ toJson .config }}
{{- end }}