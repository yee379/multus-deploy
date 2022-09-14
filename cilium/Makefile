CILIUM_BIN ?= ./cilium

apply:
	$(CILIUM_BIN) install --restart-unmanaged-pods=false --helm-values=cilium-values.yaml 

status:
	$(CILIUM_BIN) status


delete:
	$(CILIUM_BIN) uninstall
