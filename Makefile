



apply:
	# create kind cluster
	cd kind && make apply
	
	# make calico network
	cd calico && make apply
	
	# add multus
	cd multus && make apply
	
	# add cilium
	cd cilium && make apply
	
	# add cilium network attatch
	cd multus && make cilium
	
	
delete:
	cd kind && make delete
	