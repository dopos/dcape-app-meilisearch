## dcape-app-template Makefile
## This file extends Makefile.app from dcape
#:

SHELL               = /bin/bash
CFG                ?= .env
CFG_BAK            ?= $(CFG).bak

#- App name
APP_NAME           ?= search

#- Docker image name
IMAGE              ?= getmeili/meilisearch

#- Docker image tag
IMAGE_VER          ?= v1.6.1

#- Master key
MEILI_MASTER_KEY   ?= $(shell openssl rand -hex 16; echo)

#- app root
APP_ROOT           ?= $(PWD)

# ------------------------------------------------------------------------------

# if exists - load old values
-include $(CFG_BAK)
export

-include $(CFG)
export

# This content will be added to .env
# define CONFIG_CUSTOM
# # ------------------------------------------------------------------------------
# # Sample config for .env
# #SOME_VAR=value
#
# endef

# ------------------------------------------------------------------------------
# Find and include DCAPE_ROOT/Makefile
DCAPE_COMPOSE   ?= dcape-compose
DCAPE_ROOT      ?= $(shell docker inspect -f "{{.Config.Labels.dcape_root}}" $(DCAPE_COMPOSE))

ifeq ($(shell test -e $(DCAPE_ROOT)/Makefile.app && echo -n yes),yes)
  include $(DCAPE_ROOT)/Makefile.app
else
  include /opt/dcape/Makefile.app
endif

# ------------------------------------------------------------------------------

## Template support code, used once
use-template:

.default-deploy: prep

prep:
	@echo "Just to show we able to attach"

## Show server keys
show-keys:
	curl \
  -X GET 'https://$(APP_SITE)/keys' \
  -H 'Authorization: Bearer $(MEILI_MASTER_KEY)' | jq '.'

## Update search index
scrape: CMD=--profile scrape run -t --rm scraper
scrape: dc
