pipeline {
    agent any
    stages {
      stage('Lint') {
        steps {
          sh 'hadolint Dockerfile'
          sh 'flake8 api.py'
        }
      }
      stage('Build & Push') {
      	steps {
      	  sh 'docker build -t udacity .'
      	  sh 'docker tag udacity:latest 418590747430.dkr.ecr.us-west-2.amazonaws.com/udacity:latest'
      	  sh 'docker push 418590747430.dkr.ecr.us-west-2.amazonaws.com/udacity:latest'
      	}
      }
      stage('')
    }
}
