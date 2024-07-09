
# CI/CD Project for Containerized simple-java-maven-app

## Source code
the project uses a fork of the following app: \
https://github.com/jenkins-docs/simple-java-maven-app

## GitHub Actions CI/CD Stages
This GitHub Actions workflow automates the process of building, tagging and pushing a Docker image of a Java application, \
and provisioning an AWS EC2 instance using Terraform, and running the Docker Image on that EC2 instance.

## Workflow Overview
### trigger:
the workflow is triggered on Push event to `master` branch in the following paths:
```bash
on:
  push:
    branches: 
      - "master"
    paths:       
      - 'src/**'
      - 'tf-files/**'
      - '.github/workflows/**'
      - 'Dockerfile'
      - 'pom.xml'
```
## Jobs:
The workflow consists of two main jobs:
1. **Build**: This job checks out the repository, 
increments the version in the `pom.xml` file, \
builds and tags the Docker image, \
and pushes it to Docker Hub.

2. **Provision-EC2**: This job provisions an EC2 instance using Terraform.
It requires the successful completion of the `build` job.

## Steps
### 1. Job - Build

- Checkout the repository.
- Increment version in `pom.xml`.
- Get the new version from `pom.xml`.
- Build a Docker image and tag it as a new version.
- Tag the Docker image as `latest`.
- Login to Docker Hub registry (configure your secrets in GitHub).
- Push both versions (new version and `latest`) to Docker Hub.

### 2. Job - Provision EC2

- Checkout the repository.
- Configure AWS credentials.
- Initialize, validate, and apply Terraform to provision the EC2 instance.

## Multi-Stage Dockerfile

### Build and Tag Image

```bash
docker build -t ${DOCKERHUB_USERNAME}/github_app:${{env.VERSION}} --build-arg APP_VERSION=${{env.VERSION}} .
```

### Inside Dockerfile

#### Arguments & Environment Variables

`ARG APP_VERSION` - Get argument for image building

`ENV APP my-app-$APP_VERSION.jar` - Set environment variable for execution.

#### Stage 1: Build

- Copy source code.
```dockerfile
COPY . .
```

- Compile Java application and create JAR file.
```dockerfile
RUN mvn package
```

#### Stage 2: Run

- Copy JAR file from the build stage.
```dockerfile
COPY --from=maven /target/my-app-$APP_VERSION.jar .
```

- Execute the program when running the image.
```dockerfile
CMD java -jar $APP
```

## Versioning Logic
The project adheres to semantic versioning (Major.Minor.Patch) to ensure a structured and predictable versioning system.
- Increment version: This step uses a plugin to change the version number in the `pom.xml` file.
```yaml
- name: Increment version
  uses: mickem/gh-action-bump-maven-version@v1.0.0
  with:
    pom-file: 'pom.xml'
```

## Plugin Used

#### GitHub Action:
- ***actions/checkout@v4*** - Allows you to take actions on your source code.
- ***[docker/login-action@v3](https://github.com/docker/login-action)*** - Allows you to log in against a Docker registry.
- ***[mickem/gh-action-bump-maven-version@v1.0.0](https://github.com/mickem/gh-action-bump-maven-version)*** - Allows you to increment the version in your Maven `pom.xml` file.
- ***[aws-actions/configure-aws-credentials@v4.0.2](https://github.com/aws-actions/configure-aws-credentials)*** - Configures AWS credentials for use in GitHub Actions.
- ***[hashicorp/setup-terraform@v2](https://github.com/hashicorp/setup-terraform)*** - Sets up Terraform in GitHub Actions.

#### DockerFile:
- ***maven:3.8.6*** - Docker Image for building Java applications using Maven.
- ***openjdk:17-jdk-slim*** - Docker Image for running Java applications.

## Run Program Locally

```bash
docker run ${DOCKERHUB_USERNAME}/github_app:latest
```

## Links

- [Simple Java Maven App](https://github.com/jenkins-docs/simple-java-maven-app)
- [DockerHub Project Registry](https://hub.docker.com/repository/docker/${DOCKERHUB_USERNAME}/github_app)
