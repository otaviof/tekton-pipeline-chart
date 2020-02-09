{{- define "steps-buildpacks" }}
    - name: prepare
      image: alpine
      securityContext:
        runAsUser: 0
      command:
        - /bin/sh
      args:
        - -c
        - chown -R "1000:1000" "/workspace/{{ .Values.spec.source.name }}"
    - name: detect
      image: {{ .Values.spec.builderImage }}
      securityContext:
        runAsUser: 1000
      command:
        - /cnb/lifecycle/detector
      args:
        - -log-level=debug
        - -app=/workspace/{{ .Values.spec.source.name }}
        - -group=/layers/group.toml
        - -plan=/layers/plan.toml
      volumeMounts:
        - name: layers-dir
          mountPath: /layers
    - name: analyze
      image: {{ .Values.spec.builderImage }}
      securityContext:
        runAsUser: 1000
      command:
        - /cnb/lifecycle/analyzer
      args:
        - -log-level=debug
        - -layers=/layers
        - -group=/layers/group.toml
        - {{ .Values.spec.output }}
      volumeMounts:
        - name: layers-dir
          mountPath: /layers
    - name: restore
      image: {{ .Values.spec.builderImage }}
      securityContext:
        runAsUser: 1000
      command:
        - /cnb/lifecycle/restorer
      args:
        - -log-level=debug
        - -group=/layers/group.toml
        - -layers=/layers
        - -path=/cache
      volumeMounts:
        - name: cache-dir
          mountPath: /cache
        - name: layers-dir
          mountPath: /layers
    - name: build
      image: {{ .Values.spec.builderImage }}
      securityContext:
        runAsUser: 1000
      command:
        - /cnb/lifecycle/builder
      args:
        - -app=/workspace/{{ .Values.spec.source.name }}
        - -layers=/layers
        - -group=/layers/group.toml
        - -plan=/layers/plan.toml
      volumeMounts:
        - name: layers-dir
          mountPath: /layers
{{- end }}