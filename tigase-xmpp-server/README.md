# What it is?

This is a repository for a helm chart for Tigase XMPP Server

# How to use it?

## Deployment of Tigase XMPP Server

This is an example of the installation with helm using default configuration and values. 
In most cases you would need to set values for configurations options provided in file
`helm/onedev/values.yaml`

Installing Tigase XMPP Server as `tigase-server` in `tigase` namespace using local clone of the repository.
From root directory execute following command
```sh
helm install --create-namespace -n tigase xmpp-server .
```

While this is quite simple, it will not work in most cases, as Tigase XMPP Server requires database to work. 
This helm chart does not include installation of a database, but instead requires you to provide database configuration parameter.

You may want to use values file for storage of values of variables for installation, ie.:
```sh
helm install -f ../myvalues.yaml --create-namespace -n tigase xmpp-server .
```
This command will use values of variables from `../myvalues.yaml` file.

For the list of possible variables and values please check `values.yaml` file.

### Example configuration values file

```yaml
# let's have 2 pods
replicaCount: 2

# use example.com as main domain hosted on this installation
vhost: "example.com"

# set admin accounts list
admins:
  - 'admin@example.com'

database:
  type: "mysql"
  host: "mysql.tigase.svc.cluster.local"
  user: "root"
  secret: "mysql"
  # secret key which holds database password
  secretPasswordKey: "mysql-root-password"

fileUpload:
  enabled: true
  # use upload.example.com for HTTP File Upload (for file upload and download)
  domain: "upload.example.com"
  # select from s3 and persistent-volume
  storage: 's3'
  s3storage:
    bucket: 'file-upload'
    accessKeyId: "test"
    secret: "s3-upload"    
    
# we are enabling ingress and TLS to provide HTTSPS for HTTP File Upload
ingress:
  enabled: true
  tls:
    hosts:
    - "upload.example.com"
  hosts:
  - host: "upload.example.com"
    paths:
      - path: /
        pathType: Prefix
    
```

## Creation of MySQL secret

If your MySQL deployment is done in the same namespace and already created secret storing database user password you can use it by providing its name and key in `database` section values.

If not, you can execute 
```sh
kubectl create secret generic mysql --from-literal=mysql-root-password=834ysjr34w --namespace tigase
``` 
to create secret with MySQL password for use with above example yaml file.

## Creation of S3 storage secret

If you have enabled HTTP File Upload, you need to create secret with secret key for accessing S3 storage. You could do that by execution of a following command (you need to adjust values):
```sh
kubectl create secret generic s3-upload --from-literal=test=test-secret --namespace tigase
```

## Restarting Tigase pods to apply config-only changes

If you are applying config-only changes, they may not be applied automatically (k8s will not detect changes). In this case, you will need to trigger pods restart by execution of following command:
```sh
kubectl rollout restart deployment xmpp-server --namespace tigase
```
