pipeline {
    agent any

    environment {
        IMAGE_NAME = "mahdisomjee04/merged-docker"
        IMAGE_TAG = "latest"
    }

    stages {

        stage('Build Docker Image') {
            steps {
                script {
                    echo "Building Docker image..."
                    def customImage = docker.build("${IMAGE_NAME}:${IMAGE_TAG}")
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
                      -v $(pwd):/workspace \
                      -w /workspace \
                      bitnami/kubectl apply -f k8s/
                    '''
                }
            }
        }
    }

    post {
        success { echo "CI/CD → Kubernetes deployment successful 🚀" }
        failure { echo "Pipeline failed ❌" }
    }
}