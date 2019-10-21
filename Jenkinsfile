pipeline {
    agent any
    stages {
      stage('Lint Dockerfile') {
        steps {
          sh 'tidy -q -e Dockerfile'
        }
      }
    }
}
