# Docker Jenkins CI/CD Pipeline

This project demonstrates a Continuous Integration and Continuous Deployment (CI/CD) pipeline using Jenkins and Docker. The pipeline automates building, testing, and deploying a Dockerized application.

# Overview
The CI/CD pipeline performs the following steps:
- Build: Constructs a Docker image for the application.
- Push to DockerHub: Uploads the Docker image to DockerHub.
- Deploy: Deploys the Docker container on a server.

# Prerequisites
- Docker: Ensure Docker is installed and running on the server.
- Jenkins: Set up Jenkins with the necessary plugins:
    Docker Pipeline Plugin
    Credentials Binding Plugin

# Jenkins Pipeline Configuration
The Jenkins pipeline is defined in the Jenkinsfile as follows:

pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "tobiliba993/docker-jenkins-pipeline"
        DOCKER_TAG = "latest"
    }

    stages {
        stage('Build') {
            steps {
                echo 'Building Docker image...'
                script {
                    sh "docker pull $DOCKER_IMAGE:$DOCKER_TAG || true"  // Pre-pull existing image to leverage cache
                    sh "docker build -t $DOCKER_IMAGE:$DOCKER_TAG ."
                }
            }
        }

        stage('Push to DockerHub') {
            steps {
                script {
                    withDockerRegistry([credentialsId: 'docker-hub-credentials', url: "https://index.docker.io/v1/"]) {
                        sh "docker push $DOCKER_IMAGE:$DOCKER_TAG"
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploying container...'
                script {
                    // Stop and remove existing container if running
                    sh "docker stop my_app || true"
                    sh "docker rm my_app || true"

                    // Remove old image if exists
                    sh "docker rmi -f $DOCKER_IMAGE:$DOCKER_TAG || true"
                    
                    // Pull the latest image
                    sh "docker pull $DOCKER_IMAGE:$DOCKER_TAG"

                    // Run the new container
                    sh "docker run -d --name my_app -p 8081:80 $DOCKER_IMAGE:$DOCKER_TAG"
                }
            }
        }
    }
}

# Setup Instructions
# 1. Clone the Repository: Clone this repository to your local machine.
# 2. Configure Jenkins Credentials:
  - In Jenkins, navigate to Manage Jenkins > Manage Credentials.
  - Add a new credential with your DockerHub username and password.
  - Set the ID of the credential to docker-hub-credentials.

# 3. Create a Jenkins Pipeline:
  - In Jenkins, create a new Pipeline job.
  - In the Pipeline configuration, set the Pipeline script from SCM option.
  - Configure the repository URL and branch to point to this repository.

# 4. Run the Pipeline:
  - Trigger the pipeline manually or set up a webhook to start the pipeline on code changes.

# Notes
- Ensure that the Docker daemon is accessible to Jenkins. If Jenkins is running inside a Docker container, it must have access to the host's Docker daemon.
- The application will be accessible on port 8081 of the server after deployment.

# References
- Implementing CI/CD Pipelines with Docker and Jenkins
- How to Set Up a CI/CD Pipeline with Docker and Jenkins

By following this setup, you can automate the process of building, testing, and deploying your Dockerized applications using Jenkins.

