# note that the image url's are messed up; so you will still have to modify the kustomize.yaml .image.tag
MULTUS_VERSION ?= v3.9.1


update:
	curl https://raw.githubusercontent.com/k8snetworkplumbingwg/multus-cni/$(MULTUS_VERSION)/deployments/multus-daemonset-thick-plugin.yml > multus-daemonset-thick.yml

run-apply:
	kubectl apply -k .


dump:
	kubectl kustomize .

apply: run-apply


cilium:
	kubectl apply -f cilium-networkattachment.yaml

weave:
	kubectl apply -f weave-networkattachment.yaml
