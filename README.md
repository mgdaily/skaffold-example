# Skaffold Example

This is a barebones example for the purposes of illustration of how we can leverage Skaffold to develop in a Kubernetes environment.

## What does Skaffold do for us?

A: A lot of things - check out the docs for more info, I'm not going to dive into all of the functionality today. 

Skaffold's `dev` workflow is what I'll be focusing on. It chains together three common things:

* A file watcher with "hot reload" functionality. When source code changes we perform:
    * Automatic docker build (and push if desired)
    * Automatic helm deploy - in our case, to a local minikube cluster

## Prerequesites

* Skaffold
* Minikube
* Kubectl
* Docker
* Helm3

## Quick Bootstrap

Assuming you have all prerequesites installed, go ahead and launch a minikube instance

```shell
minikube start --driver=docker --kubernetes-version=1.21.0 --memory 4196 --cpus 4 --disk-size 50Gb
```

Once this is done, running `kubectl config use-context minikube` will switch your kubectl to use the minikube context (note: [kubectx](https://github.com/ahmetb/kubectx) is a nice tool for switching contexts!)

Because minikube has its own Docker daemon to manage its images, we need to point our local terminal to use minikube's docker daemon so we can build images locally and have them be available in the minikube environment.

Running `eval $(minikube docker-env)` will do just that. Now any ‘docker’ command you run in this current terminal will run against the docker inside minikube cluster. (See [minikube docs](https://minikube.sigs.k8s.io/docs/handbook/pushing/#1-pushing-directly-to-the-in-cluster-docker-daemon-docker-env))

Now, `skaffold dev` is the command we'll focus on. Run it and you'll notice:
1. It'll build the image specified in your repo's Dockerfile, tagging it based on what's in our `skaffold.yaml`
2. It'll then use the helm chart and values file specified in `skaffold.yaml` to deploy the image automatically to our minikube cluster.
3. It'll port-forward all traffic from 0.0.0.0:9000 -> port 8080 on the deployment we've specified
4. It'll automatically re-deploy when code changes!
