pipeline {
    agent any
    stages {
      stage('Lint') {
        steps {
          sh 'hadolint Dockerfile'
          sh 'flake8 api.py'
        }
      }
    }
}
