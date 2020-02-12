{{- define "steps-s2i" }}
{{- template "s2i-generate" . }}
    - name: buildah-bud
      image: quay.io/buildah/stable:latest
      workingDir: /workspace/{{ .Values.spec.source.name }}
      securityContext:
        runAsUser: 0
      args:
        - buildah
        - bud
        - --tag="{{ .Values.spec.output }}"
        - /workspace/{{ .Values.spec.source.name }}
{{- end }}
