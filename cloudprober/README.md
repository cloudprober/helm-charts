# [Cloudprober](http://cloudprober.org) Helm Chart

## Cloudprober source:

https://github.com/cloudprober/cloudprober

## Chart source:

https://github.com/cloudprober/helm-charts/tree/main/cloudprober

## To install:

```
helm repo add cloudprober https://helm.cloudprober.org/
helm repo update
helm install cloudprober cloudprober/cloudprober -n cloudprober --create-namespace
```

## To add/update the Cloudprober config

You can either add config directly in the `values.yaml`, or you can provide config on the command line through the `--set-file` flag.

```
helm upgrade --install cloudprober cloudprober/cloudprober \
    --set-file config=~/monitoring/config/cloudprober.cfg -n cloudprober
```

To specify additional configs, for including in the main config file for example:

```
helm upgrade install cloudprober cloudprober/cloudprober -n cloudprober --set-file config=cloudprober.cfg \
  --set additionalConfigs[0].name=team1.cfg --set-file additionalConfigs[0].value=cloudprober.d/team1.cfg \
  --set additionalConfigs[1].name=team2.cfg --set-file additionalConfigs[1].value=cloudprober.d/team2.cfg
```
