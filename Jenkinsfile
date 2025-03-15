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
