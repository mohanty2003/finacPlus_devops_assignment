pipeline {
  agent any
  
  parameters {
    string(name: 'IMAGE_REG', defaultValue: 'docker.io/mohanty2003', description: 'docker registry')
    string(name: 'IMAGE_NAME', defaultValue: 'sre-ci-cd-sample', description: 'image name')
    string(name: 'IMAGE_TAG', defaultValue: 'latest', description: 'image tag')
    string(name: 'K8S_NAMESPACE', defaultValue: 'dev', description: 'k8s namespace')
  }

  environment {
    DOCKER_CREDENTIALS = 'docker-registry-cred'
    KUBECONFIG_CRED = 'kubeconfig-cred'
  }

  stages {
    stage('Checkout') {
      steps {
        echo "checking out code..."
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
            sh "echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin"
            sh "docker push ${imageName}"
          }
        }
      }
    }

    stage('Deploy to K8s') {
      steps {
        withCredentials([file(credentialsId: env.KUBECONFIG_CRED, variable: 'KUBECONFIG')]) {
          script {
            def imageName = "${params.IMAGE_REG}/${params.IMAGE_NAME}:${params.IMAGE_TAG}"
            sh "kubectl apply -f k8s/"
            sh "kubectl set image deployment/sre-ci-cd-deployment sre-ci-cd-container=${imageName} -n ${params.K8S_NAMESPACE}"
            sh "kubectl rollout status deployment/sre-ci-cd-deployment -n ${params.K8S_NAMESPACE}"
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
