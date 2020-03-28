# Goal

* Switch to a processing image
* Expose an api and make a request

## Notes

### Installing keda

This is supposed to be a utility for autoscaling. Steps:

```
helm repo add kedacore https://kedacore.github.io/charts
helm repo update
kubectl create namespace keda
helm install keda kedacore/keda --namespace keda
```

### Debugging

Look at putting connection in auth params

kubectl get pods --namespace=keda
kubectl logs keda-operator-6bdf8cbb68-5n5bh --namespace=keda