UNAME:= $(shell uname)
ifeq ($(UNAME),Darwin)
		OS_X  := true
		SHELL := /bin/bash
else
		OS_DEB  := true
		SHELL := /bin/bash
endif


default:
	@echo "makefile for build and deploy"
	@echo "The following targets are available:"
	@echo " deploy 				interactive deploy to remote server"
	@echo " install 			interactive tools installation" 

install:
	@echo "installing kong, filebeat to remote server"
	./10_install.sh

deploy-blue:
	@echo "deploying blue env to remote server"
	./blue/00_deploy.sh

deploy-green:
	@echo "deploying green env to remote server"
	./green/00_deploy.sh

rollback-blue:
	@echo "rollback to the previous version"
	./blue/10_rollback.sh rollback
rollback-green:
	@echo "rollback to the previous version"
	./green/10_rollback.sh rollback
