pipeline {
    agent any

    environment {
        IMAGE_NAME = "mahdisomjee04/merged-docker:latest"
    }

    stages {

        stage('Build Docker Image') {
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

        stage('Deploy to Kubernetes') {
            steps {
                withCredentials([file(credentialsId: 'kubeconfig-creds', variable: 'KUBECONFIG')]) {
                    sh '''
                    echo "Starting kubectl container..."
                    docker run -d --name kubectl-runner \
                      -v $KUBECONFIG:/root/.kube/config \
                      bitnami/kubectl sleep 300

                    docker cp k8s kubectl-runner:/k8s
                    docker exec kubectl-runner kubectl apply -f /k8s

                    docker rm -f kubectl-runner
                    '''
                }
            }
        }
    }

    post {
        success { echo "Pipeline completed successfully ✅" }
        failure { echo "Pipeline failed ❌" }
    }
}