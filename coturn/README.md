# What it is?

This is a repository for a helm chart for CoTURN

# How to use it?

## Deployment

Installing CoTURN as `coturn` in `tigase` namespace using local clone of the repository.
From root directory execute following command
```sh
helm install --create-namespace -n tigase coturn .
```

While this is quite simple, it will not work in most cases, as CoTURN requires valid configuration to work.

You may want to use values file for storage of values of variables for installation, ie.:
```sh
helm install -f ../myvalues.yaml --create-namespace -n tigase coturn .
```
This command will use values of variables from `../myvalues.yaml` file.

For the list of possible variables and values please check `values.yaml` file.

### Example configuration values file

```yaml
# use example.com as realm for CoTURN
vhost: "example.com"

ports:
  # we are using ports from 40000 to 40020
  from: "40000"
  to: "40020"

secret:
  # name of the secret storing TURN secret
  name: "test"
  # key of the secret storing TURN secret
  key: "password"
```

## Creation of CoTURN secret

You can execute 
```sh
kubectl create secret generic test --from-literal=password=834ysjr34w --namespace tigase
``` 
to create secret with password for use with above example yaml file.

## Restarting CoTURN pods to apply config-only changes

If you are applying config-only changes, they may not be applied automatically (k8s will not detect changes). In this case, you will need to trigger pods restart by execution of following command:
```sh
kubectl rollout restart deployment coturn --namespace tigase
```
