pipeline {
    agent any

    environment {
        IMAGE_NAME = "mahdisomjee04/merged-docker"
        IMAGE_TAG = "latest"
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/mahdisomjee123/jenkins-demo.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh '''
                    echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                    docker push ${IMAGE_NAME}:${IMAGE_TAG}
                    '''
                }
            }
        }

        stage('Install kubectl') {
            steps {
                sh '''
                command -v kubectl || (
                  curl -LO https://dl.k8s.io/release/v1.35.0/bin/linux/amd64/kubectl &&
                  chmod +x kubectl &&
                  mv kubectl /usr/local/bin/
                )
                kubectl version --client
                '''
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                withCredentials([file(credentialsId: 'kubeconfig-creds', variable: 'KUBECONFIG')]) {
                    sh '''
                    export KUBECONFIG=$KUBECONFIG
                    kubectl cluster-info
                    kubectl apply -f k8s/ --validate=false
                    kubectl rollout status deployment/merged-app
                    kubectl get svc merged-app-service
                    '''
                }
            }
        }
    }

    post {
        success { echo "CI/CD Pipeline completed successfully 🚀" }
        failure { echo "Pipeline failed ❌" }
    }
}