pipeline {
    agent any

    environment {
        IMAGE_NAME = "mahdisomjee04/merged-Docker"
        IMAGE_TAG = "1.0.0"
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/mahdisomjee123/jenkins-demo.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    echo "ABC Building Docker image..."
                    // Docker plugin will use host's Docker socket
                    def customImage = docker.build("${IMAGE_NAME}:${IMAGE_TAG}")
                    // store it for later push
                    env.IMAGE_ID = customImage.id
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-creds') {
                        docker.image("${IMAGE_NAME}:${IMAGE_TAG}").push()
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