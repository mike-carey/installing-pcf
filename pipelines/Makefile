#!/usr/bin/env make

.PHONY: .params.yml

params: .params.yml

.params.yml:
	bosh int params.yml --vars-env PIPELINE --var-file git_private_key=$(GIT_PRIVATE_KEY) > .params.yml
