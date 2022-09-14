
update:
	curl -L https://cloud.weave.works/k8s/net?k8s-version=$(shell kubectl version | base64 | tr -d '\n') > weave.yaml


apply:
	kubectl apply -f weave.yaml

status:
	kubectl exec -n kube-system weave-net-527vj -c weave -- /home/weave/weave --local status

