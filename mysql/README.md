# What it is?

This is a repository for a helm chart for MySQL

# How to use it?

## Deployment of MySQL

This is an example of the installation with helm using default configuration and values. 
In most cases you would need to set values for configurations options provided in file
`values.yaml`

Installing Tigase XMPP Server as `mysql` in `tigase` namespace using local clone of the repository.
From the directory execute following command
```sh
helm install --create-namespace -n tigase mysql .
```

While this is quite simple, it will not be the best idea in most cases as it would generate root password which needs to be passed during the upgrade as a parameter.

Instead, you may want to specify root password and optionally user name and password on external yaml file.
If not you may create secret with `mysql-root-password` (and optionally `mysql-password` for regular user) manually with following command:
```
kubectl create secret generic mysql --from-literal=mysql-root-password=834ysjr34w  --from-literal=mysql-password=34tse43swt --namespace tigase
```

You may want to use values file for storage of values of variables for installation, ie.:
```sh
helm install -f ../myvalues.yaml --create-namespace -n tigase mysql .
```
This command will use values of variables from `../myvalues.yaml` file.

For the list of possible variables and values please check `values.yaml` file.

### Example configuration

In this example we will set root and user passwords for MySQL, enable persistent storage, enable backup on separate persistent storage, and enabled backup on S3 storage.

#### Custom config file
```yaml
# Configuring authentication
auth:
  rootPassword: "pa$$word"
  database: "tigasedb"
  username: "tigase"
  password: "tig1"

# enable persistent storage
persistentVolume:
  enabled: true
  
backup:
  # enable backup on persistent storage
  persistentVolume:
    enabled: true
    schedule: "5 1 * * *"
    
  # enable backup on S3
  s3:
    enabled: true
    schedule: "5 1 * * *"
    existingSecret: "mysql-s3-backup"
    endpoint: "s3.us-west-2.amazonaws.com"
    bucket: "mysql-backup"
    
```

#### Creating secret for S3 storage for MySQL backup

Before this will work, we need to create a secret with S3 configuration:
```
kubectl create secret generic mysql-s3-backup --from-literal=access-key=XX_USERNAME_XX --from-literal=secret-key=XX_PASSWORD_XX --namespace tigase
```