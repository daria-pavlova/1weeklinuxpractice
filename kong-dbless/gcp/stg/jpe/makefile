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
	@echo " login_cluster 		login into gcp cluster" 
	@echo " login_build 		build" 

login:
	@gcloud auth application-default login

build:
	@echo "installing kong, filebeat to remote server"
	./90_build.sh

login_cluster:
	@echo "installing kong, filebeat to remote server"
	./10_login_into_cluster.sh

deploy:
	@echo "deploying stg to gcp cluster"
	./00_deploy.sh


