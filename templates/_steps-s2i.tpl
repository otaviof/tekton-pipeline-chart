{{- define "steps-s2i" }}
    - name: s2i-build-as-dockerfile
      image: otaviof/s2i:latest
      workingDir: /workspace/{{ .Values.spec.source.name }}
      args:
        - build
        - .
        - {{ .Values.spec.builderImage }}
        - {{ .Values.spec.output }}
        - --as-dockerfile=Dockerfile
    - name: buildah-bud
      image: quay.io/buildah/stable:latest
      workingDir: /workspace/{{ .Values.spec.source.name }}
      args:
        - buildah
        - bud
        - --tag="{{ .Values.spec.output }}"
        - /workspace/{{ .Values.spec.source.name }}
{{- end }}
