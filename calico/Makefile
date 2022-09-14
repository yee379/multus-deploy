
create:
	kubectl create -f tigera-operator.yaml || true 

apply: create
	sleep 4
	kubectl apply -f custom-resources.yaml
