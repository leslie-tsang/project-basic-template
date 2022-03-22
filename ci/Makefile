# Makefile basic CI env setting

# Project basic setting patch for dev
project_release_folder ?= release
project_release_name   ?= $(project_release_folder)/$(project_name)_release.v$(project_version).$(project_launch_utc).tar.gz


# ENV patch for dev
ENV_MAKEFILE := $(ENV_MAKEFILE) ci/Makefile


# Hyperconverged Infrastructure patch for dev
ENV_DOCKER_COMPOSE_LINT     ?= $(ENV_DOCKER_COMPOSE) -f $(CURDIR)/ci/docker-compose.lint.yml
ENV_DOCKER_COMPOSE_DEVOPS   ?= $(ENV_DOCKER_COMPOSE) -f $(CURDIR)/ci/docker-compose.devops.yml
ENV_GIT                     ?= git
ENV_GIT_COMMIT_ID           ?= $(shell $(ENV_GIT) log -1 --pretty="%H")
ENV_SHASUM                  ?= shasum -a 512
ENV_TAR                     ?= tar


# ENV patch for darwin
ifeq ($(ENV_OS_NAME), darwin)
	# OSX archive `._` cache file
	ENV_TAR := COPYFILE_DISABLE=1 $(ENV_TAR)
endif


### Lint
### lint : Run all lint check
.PHONY: lint
lint: lint_check


### lint_build : Lint build container image
.PHONY: lint_build
lint_build:
	@$(call func_echo_status, "$@ -> [ Start ]")
	@$(ENV_DOCKER_COMPOSE_LINT) build
	@$(call func_echo_success_status, "$@ -> [ Done ]")


### lint_check : Lint check
.PHONY: lint_check
lint_check: _lint_eclint lint_clean
	@$(call func_echo_success_status, "$@ -> [ Done ]")


.PHONY: _lint_eclint
_lint_eclint:
	@$(call func_echo_status, "$@ -> [ Start ]")
	@$(ENV_DOCKER_COMPOSE_LINT) run eclint
	@$(call func_echo_success_status, "$@ -> [ Done ]")


### lint_clean : Lint clean up
.PHONY: lint_clean
lint_clean:
	@$(call func_echo_status, "$@ -> [ Start ]")
	@$(ENV_DOCKER_COMPOSE_LINT) down
	@$(call func_echo_success_status, "$@ -> [ Done ]")


### publish : Publish release in pure mode
.PHONY: publish
publish: release-clean publish-release publish-clean release
	@$(call func_echo_success_status, "$@ -> [ Done ]")


### publish-release : Launch publish container
.PHONY: publish-release
publish-release:
	@$(call func_echo_status, "$@ -> [ Start ]")
	@$(ENV_DOCKER_COMPOSE_DEVOPS) run release
	@$(call func_echo_success_status, "$@ -> [ Done ]")


### publish-clean : Clean up publish container
.PHONY: publish-clean
publish-clean:
	@$(call func_echo_status, "$@ -> [ Start ]")
	@$(ENV_DOCKER_COMPOSE_DEVOPS) down
	@$(call func_echo_success_status, "$@ -> [ Done ]")


### release : Release current project without version control
.PHONY: release
release:
	@$(call func_echo_status, "$@ -> [ Start ]")
	@if [[ ! -d $(project_release_folder) ]]; then \
		$(call func_echo_status, "create release archive folder -> $(project_release_folder)"); \
		mkdir -p $(project_release_folder); \
	fi
	$(ENV_TAR) -zcv \
		--exclude *.git \
		--exclude *.github \
		--exclude *.idea \
		--exclude *.vagrant \
		--exclude *.editorconfig \
		--exclude *.gitignore \
		--exclude *.DS_Store \
		--exclude *ci \
		--exclude *Vagrantfile \
		--exclude $(project_release_folder) \
		-f $(project_release_name) .
	@$(call func_echo_status, "$@ -> [ Commit id ] -> $(ENV_GIT_COMMIT_ID)")
	@$(ENV_SHASUM) $(project_release_name) > $(project_release_name).sha512
	@$(call func_echo_success_status, "$@ -> $(project_release_name) -> [ Done ]")


### release-clean : Clean up release result
.PHONY: release-clean
release-clean:
	@$(call func_echo_status, "$@ -> [ Start ]")
	@rm -rf $(project_release_folder)
	@$(call func_echo_success_status, "$@ -> [ Done ]")
