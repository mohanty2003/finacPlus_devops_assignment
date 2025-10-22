pipeline {
  agent any
  
  parameters {
    string(name: 'IMAGE_REG', defaultValue: 'docker.io/mohanty2003', description: 'Docker registry')
    string(name: 'IMAGE_NAME', defaultValue: 'sre-ci-cd-sample', description: 'Image name')
    string(name: 'IMAGE_TAG', defaultValue: 'latest', description: 'Image tag')
    string(name: 'K8S_NAMESPACE', defaultValue: 'dev', description: 'K8s namespace')
  }

  environment {
    DOCKER_CREDENTIALS = 'docker-registry-cred'
    KUBECONFIG_CRED = 'kubeconfig-cred' // should be a File credential in Jenkins
  }

  stages {
    stage('Checkout') {
      steps {
        echo "Checking out code..."
        checkout scm
      }
    }

    stage('Test') {
      steps {
        dir('src') {
          sh 'npm install'
          sh 'npm test'
        }
      }
    }

    stage('Build Docker Image') {
      steps {
        script {
          def imageName = "${params.IMAGE_REG}/${params.IMAGE_NAME}:${params.IMAGE_TAG}"
          sh "docker build -t ${imageName} ."
        }
      }
    }

    stage('Push to Registry') {
      steps {
        script {
          def imageName = "${params.IMAGE_REG}/${params.IMAGE_NAME}:${params.IMAGE_TAG}"
          withCredentials([usernamePassword(credentialsId: env.DOCKER_CREDENTIALS, usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
            sh """
              echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
              docker push ${imageName}
            """
          }
        }
      }
    }

    stage('Deploy to K8s') {
      steps {
        // Using File Credential for kubeconfig
        withCredentials([file(credentialsId: env.KUBECONFIG_CRED, variable: 'KUBECONFIG_FILE')]) {
          script {
            def imageName = "${params.IMAGE_REG}/${params.IMAGE_NAME}:${params.IMAGE_TAG}"
            sh """
              export KUBECONFIG=${KUBECONFIG_FILE}
              kubectl apply -f k8s/ -n ${params.K8S_NAMESPACE}
              kubectl set image deployment/sre-ci-cd-deployment sre-ci-cd-container=${imageName} -n ${params.K8S_NAMESPACE}
              kubectl rollout status deployment/sre-ci-cd-deployment -n ${params.K8S_NAMESPACE}
            """
          }
        }
      }
    }
  }

  post {
    success {
      echo "Pipeline completed successfully!"
    }
    failure {
      echo "Pipeline failed :("
    }
    always {
      sh 'docker logout || true'
    }
  }
}
