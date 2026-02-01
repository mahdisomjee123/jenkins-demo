pipeline {
    agent any

    environment {
        IMAGE_NAME = "mahdisomjee04/merged-docker:latest"
    }

    stages {

        stage('Build Docker Image') {
            steps {
                echo 'Building Docker image...'
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
                withCredentials([file(credentialsId: 'kubernetes-credss', variable: 'KUBECONFIG')]) {
                    sh '''
                    echo "Workspace:"
                    ls -l
                    echo "K8s folder:"
                    ls -l k8s

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
        success {
            echo 'Pipeline completed successfully ✅'
        }
        failure {
            echo 'Pipeline failed ❌'
        }
    }
}