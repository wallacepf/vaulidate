pipeline {
    agent any
    tools {
        go 'go1.17'
    }
    environment {
        CGO_ENABLED = 0 
        // GOPATH = "${JENKINS_HOME}/jobs/${JOB_NAME}/builds/${BUILD_ID}"
    }
    stages {        
        stage('Pre Test') {
            steps {
                echo 'Installing dependencies'
                sh 'go version'
                sh 'go get -d golang.org/x/lint/golint'
            }
        }
        
        stage('Build') {
            steps {
                echo 'Compiling and building'
                echo 'Tidying'
                sh 'go mod tidy'
                echo 'Building'
                sh 'go build'
            }
        }

        stage('Test') {
            steps {
                withEnv(["PATH+GO=${GOPATH}/bin"]){
                    echo 'Running vetting'
                    sh 'go vet .'
                    echo 'Running linting'
                    sh 'golint .'
                    sh 'ls -l'
                }
            }
        }
        
    }
}