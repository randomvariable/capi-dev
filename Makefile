CLOUD_PROVIDERS := docker aws gcp vsphere azure
CLOUD_PROVIDER_REPOS := $(addprefix cluster-api-provider-,$(CLOUD_PROVIDERS))
REPOS := cluster-api cluster-api-bootstrap-provider-kubeadm $(CLOUD_PROVIDER_REPOS)
VSCODE_REPOS := $(addprefix vscode-,$(REPOS))

init: $(REPOS)

.PHONY: vscode-workspace
vscode-workspace: $(VSCODE_REPOS)

.PHONY: vscode-%
vscode-%:
	cd $* && code -a .
	code -a .

cluster-api-provider-%:
	make sig-sponsored-checkout REPO=cluster-api-provider-$*

cluster-api-bootstrap-provider-kubeadm:
	make sis-sponsored-checkout REPO=cluster-api-bootstrap-provider-kubeadm

cluster-api:
	make sig-sponsored-checkout REPO=cluster-api

.PHONY: sig-sponsored-checkout
sig-sponsored-checkout:
	git clone https://github.com/kubernetes-sigs/$(REPO)

%/third_party/forked/rerun-process-wrapper: %
	mkdir -p $*/third_party/forked/rerun-process-wrapper
	cp -R third_party/forked/rerun-process-wrapper/* $*/third_party/forked/rerun-process-wrapper
	grep third_party/forked/rerun-process-wrapper $*/.git/info/exclude || echo third_party/forked/rerun-process-wrapper >> $*/.git/info/exclude

.PHONY: cert-manager
cert-manager:
	kubectl get ns cert-manager; if [[ $$? -ne 0 ]]; then kubectl apply  -f ./cluster-api/config/certmanager/cert-manager.yaml; kubectl wait --for=condition=Available --timeout=300s apiservice v1beta1.webhook.certmanager.k8s.io; fi