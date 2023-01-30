# Helm chart for Cloudprober

## To install:

```
helm repo add cloudprober https://helm.cloudprober.org/
helm repo update
helm install cloudprober cloudprober/cloudprober -n cloudprober
```

## To add/update config

You can either add config directly in the `values.yaml`, or you can provide config on the command line through the  `--set-file` flag.

```
helm upgrade --install cloudprober cloudprober/cloudprober \
    --set-file configFile=~/monitoring/config/cloudprober.cfg -n cloudprober
```
