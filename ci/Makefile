# Makefile basic CI env setting

# Project basic setting patch for dev
project_release_folder ?= release
project_release_name   ?= $(project_release_folder)/$(project_name)_release.v$(project_version).$(project_launch_utc).tar.gz


# ENV patch for dev
ENV_MAKEFILE := $(ENV_MAKEFILE) ci/Makefile


# Hyper-converged Infrastructure patch for dev
ENV_DOCKER_COMPOSE_DEVOPS ?= $(ENV_DOCKER_COMPOSE) -f $(CURDIR)/ci/docker-compose.devops.yml
ENV_DOCKER_COMPOSE_LINT   ?= $(ENV_DOCKER_COMPOSE) -f $(CURDIR)/ci/docker-compose.lint.yml
ENV_GIT                   ?= $(shell $(ENV_COMMAND_V) git)
ENV_GIT_COMMIT_ID         ?= $(shell $(ENV_GIT) log -1 --pretty="%H")
ENV_MKDIR                 ?= $(shell $(ENV_COMMAND_V) mkdir) -p
ENV_RM                    ?= $(shell $(ENV_COMMAND_V) rm) -vf
ENV_SHASUM                ?= $(shell $(ENV_COMMAND_V) sha512sum)
ENV_TAR                   ?= $(shell $(ENV_COMMAND_V) tar)


# ENV patch for darwin
ifeq ($(ENV_OS_NAME), darwin)
	# OSX archive `._` cache file
	ENV_TAR    := COPYFILE_DISABLE=1 $(ENV_TAR) --no-xattrs
	ENV_SHASUM := $(shell $(ENV_COMMAND_V) shasum) -a 512
endif


### DevOPS
### devops : Run DevOPS container
.PHONY: devops
devops: _devops devops_clean
	@$(call func_echo_success_status, "$@ -> [ Done ]")


### devops_build : Build DevOPS container image
.PHONY: devops_build
devops_build:
	@$(call func_echo_status, "$@ -> [ Start ]")
	@$(ENV_DOCKER_COMPOSE_DEVOPS) build devops
	@$(call func_echo_success_status, "$@ -> [ Done ]")


### devops_clean : Clean up DevOPS container
.PHONY: devops_clean
devops_clean:
	@$(call func_echo_status, "$@ -> [ Start ]")
	@$(ENV_DOCKER_COMPOSE_DEVOPS) down --remove-orphans
	@$(call func_echo_success_status, "$@ -> [ Done ]")


.PHONY: _devops
_devops:
	@$(call func_echo_status, "$@ -> [ Start ]")
	@$(ENV_DOCKER_COMPOSE_DEVOPS) run --service-ports devops bash
	@$(call func_echo_success_status, "$@ -> [ Done ]")


.PHONY: _devops_release
_devops_release:
	@$(call func_echo_status, "$@ -> [ Start ]")
	@$(ENV_DOCKER_COMPOSE_DEVOPS) run release
	@$(call func_echo_success_status, "$@ -> [ Done ]")


### Lint
### lint : Run lint check
.PHONY: lint
lint: _lint_eclint _lint_spellcheck lint_clean
	@$(call func_echo_success_status, "$@ -> [ Done ]")


### lint_build : Lint build container image
.PHONY: lint_build
lint_build:
	@$(call func_echo_status, "$@ -> [ Start ]")
	@$(ENV_DOCKER_COMPOSE_LINT) build
	@$(call func_echo_success_status, "$@ -> [ Done ]")


### lint_clean : Lint clean up
.PHONY: lint_clean
lint_clean:
	@$(call func_echo_status, "$@ -> [ Start ]")
	@$(ENV_DOCKER_COMPOSE_LINT) down --remove-orphans
	@$(call func_echo_success_status, "$@ -> [ Done ]")


.PHONY: _lint_eclint
_lint_eclint:
	@$(call func_echo_status, "$@ -> [ Start ]")
	@$(ENV_DOCKER_COMPOSE_LINT) run eclint
	@$(call func_echo_success_status, "$@ -> [ Done ]")


.PHONY: _lint_spellcheck
_lint_spellcheck:
	@$(call func_echo_status, "$@ -> [ Start ]")
	@$(ENV_DOCKER_COMPOSE_LINT) run spellcheck
	@$(call func_echo_success_status, "$@ -> [ Done ]")


### Publish
### publish : Publish release in pure mode
.PHONY: publish
publish: _devops_release devops_clean
	@$(call func_echo_success_status, "$@ -> [ Done ]")


### release : Release current project without version control
.PHONY: release
release: _release release_build
	@$(call func_echo_status, "$@ -> [ Start ]")
	@if [[ ! -d $(project_release_folder) ]]; then \
		$(call func_echo_status, "create release archive folder -> $(project_release_folder)"); \
		$(ENV_MKDIR) $(project_release_folder); \
	fi
	$(ENV_TAR) -zcv \
		--exclude *.git \
		--exclude *.github \
		--exclude *.idea \
		--exclude *.vscode \
		--exclude *.vagrant \
		--exclude *.editorconfig \
		--exclude *.gitignore \
		--exclude *.DS_Store \
		--exclude .ignore_words \
		--exclude *ci \
		--exclude *Vagrantfile \
		--exclude $(project_release_folder) \
		-f $(project_release_name) .
	@$(call func_echo_status, "$@ -> [ Commit id ] -> $(ENV_GIT_COMMIT_ID)")
	@$(ENV_SHASUM) $(project_release_name) > $(project_release_name).sha512
	@$(call func_echo_success_status, "$@ -> $(project_release_name) -> [ Done ]")


### release_build : Build release artifact
.PHONY: release_build
release_build:
	@$(call func_echo_status, "$@ -> [ Start ]")
	@$(call func_echo_success_status, "$@ -> [ Done ]")


### release_clean : Clean up release artifact
.PHONY: release_clean
release_clean:
	@$(call func_echo_status, "$@ -> [ Start ]")
	@$(ENV_RM) -r $(project_release_folder)
	@$(call func_echo_success_status, "$@ -> [ Done ]")


.PHONY: _release
_release:
	@# cache launch utc
	$(eval project_launch_utc := $(project_launch_utc))
