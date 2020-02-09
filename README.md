# Tekton Pipeline Helm-Chart

This Helm-Chart aims to generate Tekton resources, Pipeline and Tasks, in order to run known
contaimer image builders, like [`source-to-image`][s2i] and [`buildpacks`][buildpacks] as Tekton
resources.

Using this chart we can easily simulate inputs, as `values.yaml` representation, and which resources
we need to generate in Tekton to achieve the objective.

## Usage

```sh
helm install --dry-run tkn .
helm template tkn .
```

## Code Repository

The application source code must be already present as a `PipelineResource` in the cluster. Like for
example:

```yml
---
apiVersion: tekton.dev/v1alpha1
kind: PipelineResource
metadata:
  name: repository
spec:
  type: git
  params:
    - name: revision
      value: master
    - name: url
      value: https://github.com/sclorg/nodejs-ex.git
```

The name `repository` is referenced by default in example `values.yaml` entries.

## Strategies

This Helm-Chart allows you to represent different strageties, as in the builder system employed to
construct container images.

### `buildpacks`

Using [Tekton Catalog's buildpack][tkncatalogbuildpack] as exemple, it defines the Cloud Native
Builder lifecycle commands to execute:

- *Detect*: runs `detector`, to recognize the code base platform, as Ruby, Python, Node.js, etc;
- *Analyze*: runs `analyzer`, to inspect existing image for catching and metadata;
- *Restore*: runs `restorer`, to restore previous application status, keeping a building cache;
- *Build*: runs `builder`, to execute the container image build based on conclusions taken in the
previous steps;

A example of *buildpacks* stragegy is [here](./values.yaml).

### `s2i`

Using `source-to-image` container image, we can use `s2i` to generate the project at hand a
`Dockerfile` and later on calling out `s2i` workflow scripts, in the builder image.

- `Dockerfile`: generate by `s2i`;
- `buildah`: creates a final container image;

A example of *s2i* stragegy values is [here](./values-s2i.yaml).

### `custom`

Additionally, you can employ *custom* stragegy to run your own [Tekton Task steps][tkntasksteps].
Please consider the example [here](./values-custom.yaml)


[buildpacks]: https://buildpacks.io
[s2i]: https://github.com/openshift/source-to-image
[tkncatalogbuildpack]: https://github.com/tektoncd/catalog/tree/master/buildpacks
[tkntasksteps]: https://github.com/tektoncd/pipeline/blob/master/docs/tasks.md#steps