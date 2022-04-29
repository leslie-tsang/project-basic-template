# Makefile basic env setting
.DEFAULT_GOAL := help
## add pipefail support for default shell
SHELL := /bin/bash -o pipefail


# Project basic setting
project_name            ?= project_template
project_version         ?= 0.0.0
project_launch_utc      ?= $(shell date +%Y%m%d%H%M%S)


# Runtime configure


# Hyper-converged Infrastructure
ENV_OS_NAME          ?= $(shell uname -s | tr '[:upper:]' '[:lower:]')
ENV_OS_ARCH          ?= $(shell uname -m | tr '[:upper:]' '[:lower:]')
ENV_COMMAND_V        ?= command -v
ENV_DOCKER_COMPOSE   ?= docker-compose -p $(project_name) --project-directory $(CURDIR)
ENV_MAKE             ?= $(shell $(ENV_COMMAND_V) make)
ENV_MAKEFILE         ?= Makefile
ENV_HELP_PREFIX_SIZE ?= 20

# AWK patch for mawk
ifneq ($(shell $(ENV_COMMAND_V) gawk),)
	ENV_HELP_AWK_RULE ?= '{ if(match($$0, /^\s*\#{3}\s*([^:]+)\s*:\s*(.*)$$/, res)){ printf("    make %-$(ENV_HELP_PREFIX_SIZE)s : %-10s\n", res[1], res[2]) } }'
else
	ENV_HELP_AWK_RULE := '{ if(match($$0, /^\#\#\#([^:]+):(.*)$$/)){ split($$0, res, ":"); gsub(/^\#\#\#[ ]*/, "", res[1]); _desc=$$0; gsub(/^\#\#\#([^:]+):[ \t]*/, "", _desc); printf("    make %-$(ENV_HELP_PREFIX_SIZE)s : %-10s\n", res[1], _desc) } }'
endif

# ENV patch for darwin
ifeq ($(ENV_OS_NAME), darwin)
	ENV_HELP_AWK_RULE := '{ if(match($$0, /^\#{3}([^:]+):(.*)$$/)){ split($$0, res, ":"); gsub(/^\#{3}[ ]*/, "", res[1]); _desc=$$0; gsub(/^\#{3}([^:]+):[ \t]*/, "", _desc); printf("    make %-$(ENV_HELP_PREFIX_SIZE)s : %-10s\n", res[1], _desc) } }'
endif


# Makefile basic extension function
_color_red    =\E[1;31m
_color_green  =\E[1;32m
_color_yellow =\E[1;33m
_color_blue   =\E[1;34m
_color_wipe   =\E[0m
_echo_format  ="[%b info %b] %s\n"


define func_echo_status
	printf $(_echo_format) "$(_color_blue)" "$(_color_wipe)" $(1)
endef


define func_echo_warn_status
	printf $(_echo_format) "$(_color_yellow)" "$(_color_wipe)" $(1)
endef


define func_echo_success_status
	printf $(_echo_format) "$(_color_green)" "$(_color_wipe)" $(1)
endef


define func_echo_error_status
	printf $(_echo_format) "$(_color_red)" "$(_color_wipe)" $(1)
endef


# Makefile target

# Include dev Makefile
-include $(CURDIR)/ci/Makefile

### help : Show Makefile rules
.PHONY: help
help:
	@$(call func_echo_success_status, "Makefile rules:")
	@echo
	@cat $(ENV_MAKEFILE) | awk $(ENV_HELP_AWK_RULE)
	@echo
