pipeline {
    agent any
    environment {
        AZURE_CREDENTIALS_ID = 'd7275543-ce7f-43fa-a0e2-42fb409b0b47'
    }
    
    stages {
        stage('Azure CLI Login') {
            steps {
                withAzureServicePrincipal(credentialsId: "${AZURE_CREDENTIALS_ID}") {
                    sh 'az login --service-principal -u $AZURE_CLIENT_ID -p $AZURE_CLIENT_SECRET --tenant $AZURE_TENANT_ID'
                }
            }
        }
        stage('Checkout') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/main']], userRemoteConfigs: [[url: 'https://github.com/Srutik/Role-Policy-with-TF.']]])
            }
        }
        stage('Terraform Init') {
            steps {
                script {
                    sh 'terraform init'
                }
            }
        }
        stage('Terraform Validate') {
            steps {
                script {
                    sh 'terraform validate'
                }
            }
        }
    }
    post {
        always {
            cleanWs()
        }
    }
}
