# udacity-capstone

This projects contains the code and infrastructure code to deploy an Hello World Flask API on Amazon EKS.

In order to pass the capstone exam, there is a screenshot folder showing the linting step and the rolling deployment with Jenkins

All the code is accessible here : https://github.com/gfalcone/udacity-capstone

## Infrastructure

In order to deploy the application, we need to have a working infrastructure.

First, we create the network infrastructure :

```bash
sh infrastructure/create.sh udacity network.yml network-parameters.json
```

Then we create the EKS Control Panel and the associated workers :

```bash
sh infrastructure/create.sh eks-stack cluster.yml cluster-parameters.json
```

Then configure your Kubernetes cluster to add the workers :

Retrieve the template configmap

```bash
curl -o aws-auth-cm.yaml https://amazon-eks.s3-us-west-2.amazonaws.com/cloudformation/2019-10-08/aws-auth-cm.yaml
```

Replace the ARN of instance role in the following file :

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
    - rolearn: <ARN of instance role (not instance profile)>
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
```

And apply the configmap:

```bash
kubectl apply -f aws-auth-cm.yaml
```

And finally, get the kubeconfig to interact with the cluster :

```bash
aws eks --region us-west-2 update-kubeconfig --name KubernetesCluster
```

## Application

The application is just a Hello World web server implemented with Flask

First, build the application and push to repository:

```bash
docker build -t udacity .
docker tag udacity:latest 418590747430.dkr.ecr.us-west-2.amazonaws.com/udacity:latest
docker push 418590747430.dkr.ecr.us-west-2.amazonaws.com/udacity:latest
```

Then deploy application to Kubernetes:

```bash
kubectl apply -f deploy.yaml
```

This script contains :
- A deployment that creates 3 pods with the Hello World container
- A service of type LoadBalancer so that the API can be accessible from the Internet

In order to do the rolling deployment, the CI does this :

```bash
kubectl set image deployment/hello-world-api image=418590747430.dkr.ecr.us-west-2.amazonaws.com/udacity:latest
```

This triggers automatically a rolling replacement of the running container (even if this one has not changed).

Basically it forces Kubernetes to set the new image

## CI/CD

The CI is done with Jenkins and does the following steps :
- Lint Dockerfile and Python file
- Build & Push Docker container to AWS container repository
- Rolling deployment on Kubernetes