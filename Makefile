# include env variables from .env file
include .env

# Define the image name
IMAGE_NAME = de_dockerized
DOCKER_ID_USER = zhangsu0528
# Define the PORT variable
PORT = 5000

# Show Docker information
image_show:
	docker images

container_show:
	docker ps

# Docker Hub authentication
login:
	echo "$(DOCKER_TOKEN)" | docker login -u $(DOCKER_ID_USER) --password-stdin

# Combined build command that includes login and push
build: login
	docker build -t $(IMAGE_NAME) .
	docker tag $(IMAGE_NAME) $(DOCKER_ID_USER)/$(IMAGE_NAME):latest
	docker push $(DOCKER_ID_USER)/$(IMAGE_NAME):latest

# Run the Docker container
run:
	@echo "==> Stopping any containers using port $(PORT)..."
	-docker stop $$(docker ps -q --filter publish=$(PORT))
	@echo "==> Starting new container..."
	docker run -d -p $(PORT):$(PORT) $(IMAGE_NAME)


# Stop all running containers
stop:
	docker stop $$(docker ps -a -q)

# Remove the Docker image
clean:
	@echo "==> Stopping containers..."
	-docker stop $$(docker ps -a -q --filter ancestor=$(IMAGE_NAME))
	@echo "==> Removing containers..."
	-docker rm -f $$(docker ps -a -q --filter ancestor=$(IMAGE_NAME))
	@echo "==> Removing image..."
	-docker rmi -f $(IMAGE_NAME)
	@echo "==> Clean complete"

check-port:
	@echo "==> Checking port $(PORT) usage..."
	-docker ps --filter publish=$(PORT)

push:
	docker tag $(IMAGE_NAME) $(DOCKER_ID_USER)/$(IMAGE_NAME)
	docker push $(DOCKER_ID_USER)/$(IMAGE_NAME):latest

# Development workflow
dev: build run

logs:
	docker logs $$(docker ps -a -q --filter ancestor=$(IMAGE_NAME) --format="{{.ID}}")

.PHONY: build run stop clean check-port image_show container_show push login dev logs
