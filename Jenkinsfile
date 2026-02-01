pipeline {
    agent any

    environment {
        IMAGE_NAME = "mahdisomjee04/merged-docker:latest"
    }

    stages {

        stage('Build Dockerr Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME .'
            }
        }

        stage('Push Docker Image') {
            steps {
                withDockerRegistry(credentialsId: 'dockerhub-creds', url: '') {
                    sh 'docker push $IMAGE_NAME'
                }
            }
        }

        stage('Install kubectl') {
            steps {
                sh '''
                if ! command -v kubectl >/dev/null 2>&1; then
                  curl -LO https://dl.k8s.io/release/$(curl -Ls https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl
                  chmod +x kubectl
                  mv kubectl /usr/local/bin/
                fi
                kubectl version --client
                '''
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                withCredentials([file(credentialsId: 'kubeconfig-creds', variable: 'KUBECONFIG')]) {
                    sh '''
                    export KUBECONFIG=$KUBECONFIG
                    kubectl apply -f k8s/
                    kubectl rollout status deployment/merged-app
                    kubectl get svc merged-app-service
                    '''
                }
            }
        }
    }

    post {
        success { echo "CI/CD to Kubernetes completed successfully 🚀" }
        failure { echo "Pipeline failed ❌" }
    }
}