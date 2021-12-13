# What it is?

This is a repository for a helm chart for Janus

# How to use it?

## Deployment

Installing Janus as `janus` in `tigase` namespace using local clone of the repository.
From root directory execute following command
```sh
helm install --create-namespace -n tigase janus .
```

While this is quite simple, it will not work in most cases, as CoTURN requires valid configuration to work.

You may want to use values file for storage of values of variables for installation, ie.:
```sh
helm install -f ../myvalues.yaml --create-namespace -n tigase janus .
```
This command will use values of variables from `../myvalues.yaml` file.

For the list of possible variables and values please check `values.yaml` file.

### Example configuration values file

```yaml
imagePullSecrets:
  - name: tigase-aws-ecr-secret
```

## Creation of tigase-aws-ecr-secret secret

This secret is required by k8s to access AWS ECR repository and download Janus custom image.

It can be easily created with following command:
```sh
kubectl create secret docker-registry tigase-aws-ecr-secret --docker-username=AWS --docker-password=$(aws ecr get-login-password) --docker-email="<YOUR_EMAIL_HERE>" --docker-server=<DOCKER_REPO_SERVER> --namespace tigase 
```
assuming that your local computer has credentials required to access AWS account and create required token.

## Notes

Token is valid only for 24h, so we should find a way to make this automatic - retrieve and refresh token/secret every few hours, see https://stackoverflow.com/questions/54128535/kubernetes-cronjob-and-updating-a-secret/56190763#56190763
