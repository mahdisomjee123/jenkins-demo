pipeline {
    agent any

    environment {
        IMAGE_NAME = "mahdisomjee04/merged-docker" // lowercase is safer
        IMAGE_TAG = "1.0.0"
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'docker-demo', url: 'https://github.com/mahdisomjee123/jenkins-demo.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    echo "Building Docker image..."
                    def customImage = docker.build("${IMAGE_NAME}:${IMAGE_TAG}")
                    env.IMAGE_ID = customImage.id
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-creds') {
                        docker.image("${IMAGE_NAME}:${IMAGE_TAG}").push()
                        docker.image("${IMAGE_NAME}:${IMAGE_TAG}").push("latest") // optional
                    }
                }
            }
        }
    }

    post {
        success { echo "Docker image successfully built and pushed 🚀" }
        failure { echo "Pipeline failed ❌" }
    }
}