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
                git branch: 'main', url: 'https://github.com/mahdisomjee123/jenkins-demo.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    echo "Building Docker image..."
                    // Build using Docker Pipeline plugin
                    docker.build("${IMAGE_NAME}:${IMAGE_TAG}")
                }
            }
        }

        stage('Push Docker Image to DockerHub') {
            steps {
                script {
                    echo "Pushing Docker image to DockerHub..."
                    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-creds') {
                        docker.image("${IMAGE_NAME}:${IMAGE_TAG}").push()
                    }
                }
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