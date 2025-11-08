include ../../../make.inc
include .env

.PHONY: build_docker_image run_docker_image push_docker_image deploy_docker_image

build_docker_image:
	docker build -t $(DOCKER_IMAGE_NAME):$(IMAGE_TAG) .

run_docker_image:
	docker run --rm -e PORT=$(PORT) -p $(PORT):$(PORT) $(DOCKER_IMAGE_NAME):$(IMAGE_TAG)

push_docker_image:
	docker tag "$(DOCKER_IMAGE_NAME):$(IMAGE_TAG)" "$(HOSTNAME)/$(PROJECT_ID)/$(REPOSITORY)/$(DOCKER_IMAGE_NAME):$(IMAGE_TAG)"
	docker push $(HOSTNAME)/$(PROJECT_ID)/$(REPOSITORY)/$(DOCKER_IMAGE_NAME):$(IMAGE_TAG)

deploy_docker_image:
	gcloud run deploy fast-app \
	--image $(HOSTNAME)/$(PROJECT_ID)/$(REPOSITORY)/$(DOCKER_IMAGE_NAME):$(IMAGE_TAG) \
	--region=$(LOCATION) \
	--allow-unauthenticated \
	--port $(PORT)
