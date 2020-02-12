{{- define "steps-kaniko" }}
{{- template "s2i-generate" . }}
    - name: kaniko
      image: gcr.io/kaniko-project/executor
      env:
        - name: "DOCKER_CONFIG"
          value: "/tekton/home/.docker/"
      securityContext:
        runAsUser: 0
      workingDir: /workspace/{{ .Values.spec.source.name }}
      args:
        - --dockerfile=Dockerfile
        - --destination={{ .Values.spec.output }}
        - --no-push
        - --verbosity=debug
{{- end }}