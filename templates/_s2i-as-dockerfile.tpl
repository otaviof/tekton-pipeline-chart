{{- define "s2i-generate" }}
    - name: s2i-generate
      image: otaviof/s2i:latest
      securityContext:
        runAsUser: 0
      workingDir: /workspace/{{ .Values.spec.source.name }}
      args:
        - generate
        - docker://{{ .Values.spec.builderImage }}
        - /workspace/{{ .Values.spec.source.name }}/Dockerfile
    - name: s2i-chown-dockerfile
      image: alpine
      securityContext:
        runAsUser: 0
      args:
        - -c
        - chown "1000:1000" "/workspace/{{ .Values.spec.source.name }}/Dockerfile"
{{- end }}