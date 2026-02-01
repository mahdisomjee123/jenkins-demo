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