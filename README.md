# Cluster API Development Environment

This repo houses some tools to make running Cluster API v1alpha2 a little bit easier.

## Repo Setup

Run `make init`. This will clone some basic providers for you to try.

## Install Tilt

https://docs.tilt.dev/install.html

## Get a kubernetes cluster

Use kind, set up a cluster on AWS, GCP, etc. Whatever works. This will be your management cluster.

### AWS (recommended for os x)

Assuming your local environment is set up for AWS access, run:

run `./single-node-cluster-quickstart/setup.sh`.

This will create a single node kubernetes control plane to be used as the management cluster.

This will grab the kubeconfig and put it at `./single-node-cluster-quickstart/dev-kubeconfig`.
 
### kind (recommended for linux)

[Install kind](https://github.com/kubernetes-sigs/kind#please-see-our-documentation-for-more-in-depth-installation-etc)

Run kind with the provided config `kind create cluster --config ./devenv/kind/config.yaml`

Set KUBECONFIG.

## Update config.json 

Make sure you update the values in `config.json ` to point to your registry,
and set the provider you want to test.

```json
{
  "default_registry": "fabrikom-repository.com/capi",
  "default_images": {
    "custom_provider_image": "gcr.io/k8s-staging-cluster-api/cluster-api-controller"
  },
  "k8s_contexts": [
    "kubernetes-admin@home"
  ],
  "provider": "aws"
}
```

## Run Tilt

run `tilt up`

## Iterate

Now you can quickly iterate on Cluster API

