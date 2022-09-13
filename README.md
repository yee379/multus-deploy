# Multus Testbed

This is a test of the Multus network CNI delegator using calico and cilium as primary and secondary overlay networks.

## Overview

We have standardised on using calico as our k8s-pod-network in our kubernetes clsuters. However, there are features availabe in other CNI's that are useful to us. Examples include multicast networking with weave, egress gateways with calico etc etc. As such, it is necessary to utilise multiple CNI's across different environments. As we operator a single large multi-tenant cluster, the overhead of operating silos of k8s clusters for each group/project is untenable.

## Pre-reqs

As this uses kind, one must install it first. On the mac, you will need docker-desktop and kind (`brew install kind`).

## Proceedure

### Start up Kind kubernetes cluster locally

```
kind create cluster --name=cni-test --config=kind/kind-cni.yaml
```

#### Grab kubeconfig

```
kind get kubeconfig --name=cni-test > ~/.kube/config
export KUBECONFIG=~/.kube/config
```

### Install Calico

```
kubectl create -f calico/tigera-operator.yaml 
kubectl apply -f calico/custom-resources.yaml
```

### Install Multus

```
( cd multus && make apply )
```

### Install Cilium

```
( cd cilium && ./cilium install --restart-unmanaged-pods=false --helm-values=cilium-values.yaml )
```

#### Register Cilium with Multus

```
kubectl apply -f multus/cilium-networkattachment.yaml
```


## Testing

Lets do simple ping tests between pods to ensure that the networks are working.

Spin up 3 pods, the first two have both calico and cilium configured, and the final one with only calico

```
kubectl apply -f utils/netshoot.yaml -f utils/netshoot2.yaml -f utils/netshoot3.yaml
```

check for connected network interfaces:

```
keti netshoot -- ip a
```

Note that eth0 is the default k8s network, and net1 has been created as part of the `annotation` in the pod definition to add cilium.

you can determine the secondary interface's ip address with a `kubectl get netshoot -o yaml`. reaping the ip's we have the two netshoot pods with ips 10.1.0.57 and 10.1.0.238


## Details

We install calico with the detail network of 192.168.0.0/16. Ie all pods will be spun up on this subnet that is routed by calico.

We then install multus and hard code that the 'master' CNI should be calico using a kustomize patch definition to overload the multus daemonset with `-multus-master-cni-file=10-calico.conflist`. Notice that multus will by default set up a `00-multus.conf` on each k8s worker nodes CNI config path under `/etc/cni/net.d/` - this will ensure that it is always used as the k8s CNI and then delegates the network stuff over to calico.

We then spin up cilium, ensuring that we do not disturb the existing pods and network with `--restart-unmanaged-pods=false`, and we ensure that the IP range for cilium does not overlap with that of any other network (especially that of calico). If it did, we should have a difficult time routing traffic from the pods into the appropriate CNI. We also force that cilium does not have exclusive use of the hosts using `.cni.exclusive=false`.


## Misc

Check cilium node IP range assignments:

```
k get cn cni-test-worker -o yaml
``` 
