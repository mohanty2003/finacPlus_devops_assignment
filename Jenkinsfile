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
    KUBECONFIG_CRED = 'kubeconfig-cred' // Secret text in Jenkins
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
        withCredentials([string(credentialsId: env.KUBECONFIG_CRED, variable: 'KUBECONFIG_CONTENT')]) {
          script {
            sh '''
              echo "$KUBECONFIG_CONTENT" > kubeconfig.tmp
              export KUBECONFIG=$(pwd)/kubeconfig.tmp
              kubectl apply -f k8s/ -n ${K8S_NAMESPACE}
              kubectl set image deployment/sre-ci-cd-deployment sre-ci-cd-container=${IMAGE_REG}/${IMAGE_NAME}:${IMAGE_TAG} -n ${K8S_NAMESPACE}
              kubectl rollout status deployment/sre-ci-cd-deployment -n ${K8S_NAMESPACE}
              rm -f kubeconfig.tmp
            '''
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
