pipeline {
    agent any

    environment {
        IMAGE_NAME = "mahdisomjee04/merged-docker" // lowercase is safer
        IMAGE_TAG = "3.0.0"
    }

    stages {

        stage('Try') {
            steps {
                echo "hello i have startyed"
            }
        }

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
                    }
                }
            }
        }


        stage('Deploy to Kubernetes') {
            steps {
                withCredentials([file(credentialsId: 'kubeconfig-creds', variable: 'KUBECONFIG')]) {
                    sh '''
                    docker run --rm \
                      -v $KUBECONFIG:/root/.kube/config \
                      bitnami/kubectl \
                      apply -f k8s/
                    '''
                }
            }
        }
    }

    post {
        success { echo "Docker → Kubernetes deployment completed 🚀" }
        failure { echo "Pipeline failed ❌" }
    }
}