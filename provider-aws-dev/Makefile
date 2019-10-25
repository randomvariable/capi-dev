../cluster-api-provider-aws/bin/clusterawsadm:
	cd .. && make cluster-api-provider-aws
	cd ../cluster-api-provider-aws && make clusterawsadm

delete-cloudformation:
	aws cloudformation delete-stack --stack-name ClusterAPIDevEnvironment
	aws cloudformation wait stack-delete-complete --stack-name ClusterAPIDevEnvironment

.PHONY sed:
sed:
	@sed --version >/dev/null 2>&1 && sed -i -- '$(ARGS)' $(FILE) || sed -i "" '$(ARGS)' $(FILE)
:
.manifests/aws/manager/aws-credentials.done: ../cluster-api-provider-aws/bin/clusterawsadm
	$(eval BASE64_ENCODED_CREDS := $(shell ../cluster-api-provider-aws/bin/clusterawsadm alpha bootstrap encode-aws-credentials | tr -d '\n'))
	mkdir -p .manifests/aws
	cp -R ../cluster-api-provider-aws/config/* ./.manifests/aws/
	@$(MAKE) sed ARGS='s/credentials: .*/credentials: "$(BASE64_ENCODED_CREDS)"/' FILE='./.manifests/aws/manager/credentials.yaml'
	touch .manifests/aws/manager/aws-credentials.done

../cluster-api-provider-aws/third_party/forked/rerun-process-wrapper:
	cd ../cluster-api-provider-aws && make cluster-api-provider-aws
	mkdir -p ../cluster-api-provider-aws/third_party/forked/rerun-process-wrapper
	cp -R third_party/forked/rerun-process-wrapper/* ../cluster-api-provider-aws/third_party/forked/rerun-process-wrapper
	echo third_party/forked/rerun-process-wrapper >> ../cluster-api-provider-aws/.git/info/exclude	

nuke: nuke.yaml
	aws-nuke -c nuke.yaml --access-key-id $${AWS_ACCESS_KEY_ID} --secret-access-key $${AWS_SECRET_ACCESS_KEY} --force --no-dry-run

nuke.yaml:
	export CAPI_DEV_AWS_ACCOUNT_ID=$$(pass show dev/capi/aws-account-id); cat nuke.template.yaml | envsubst > nuke.yaml


test.kubeconfig:
	kubectl get secret -n aws-test aws-test-kubeconfig  -o jsonpath='{.data.value}' | base64 -d > test.kubeconfig
	echo export KUBECONFIG=$(PWD)/test.kubeconfig

.PHONY: test-cluster
aws-cluster:
	-kubectl create namespace aws-test
	kubectl apply -f example-cluster.yaml -n aws-test
