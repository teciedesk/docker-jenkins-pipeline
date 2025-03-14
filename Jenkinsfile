pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "tecie/docker-jenkins-pipeline"
        DOCKER_TAG = "latest"
    }

    stages {
        stage('Build') {
            steps {
                echo 'Building Docker image...'
                script {
                    // Remove existing image to avoid conflicts
                    sh "docker rmi -f $DOCKER_IMAGE:$DOCKER_TAG || true"
                    
                    // Build the Docker image
                    sh "docker build -t $DOCKER_IMAGE:$DOCKER_TAG ."
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                echo 'Pushing image to Docker Hub...'
                script {
                    withDockerRegistry([credentialsId: 'docker-hub-credentials', url: '']) {
                        sh "docker push $DOCKER_IMAGE:$DOCKER_TAG"
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploying container...'
                script {
                    // Ensure no existing container is running
                    sh "docker stop my_app || true && docker rm my_app || true"
                    
                    // Run the new container
                    sh "docker run -d --name my_app -p 8080:80 $DOCKER_IMAGE:$DOCKER_TAG"
                }
            }
        }
    }
}
