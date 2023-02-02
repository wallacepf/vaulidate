pipeline {
    agent any
    tools {
        go 'go1.17'
    }
    environment {
        CGO_ENABLED = 0 
        // GOPATH = "${JENKINS_HOME}/jobs/${JOB_NAME}/builds/${BUILD_ID}"
        registry = "wallacepf/vaulidate"
    }
    stages {        
        stage('Pre Test') {
            steps {
                echo 'Installing dependencies'
                sh 'go version'
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

        stage('Publish') {
            environment {
                registryCredential = 'dockerhub'
            }
            steps {
                script {
                    def appimage = docker.build registry + ":$BUILD_NUMBER"
                    docker.withRegistry( '' , registryCredential ) {
                        appimage.push
                        appimage.push('latest')
                    }
                }
            }
        }

    }
}
