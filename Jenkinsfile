pipeline {
    agent any

    environment {
        IMAGE_NAME = "mahdisomjee04/merged-docker"
        IMAGE_TAG = "1.0.0"
    }

    stages {

        stage('Checkout Code') {
            steps {
                echo "Fetching source code from GitHub..."
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
                }
            }
        }

        stage('Login to DockerHub') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'dockerhub-creds',
                        usernameVariable: 'DOCKER_USER',
                        passwordVariable: 'DOCKER_PASS'
                    )
                ]) {
                    sh "echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin"
                }
            }
        }

        stage('Push Image to DockerHub') {
            steps {
                sh "docker push ${IMAGE_NAME}:${IMAGE_TAG}"
            }
        }
    }

    post {
        success {
            echo "Docker image successfully built and pushed 🚀"
        }
        failure {
            echo "Pipeline failed ❌"
        }
    }
}