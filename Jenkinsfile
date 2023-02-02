def secrets = [
  [path: 'secrets/vault-poc', engineVersion: 2, secretValues: [
    [envVar: 'USERNAME', vaultKey: 'username'],
    [envVar: 'PASSWORD', vaultKey: 'password']]],
]
def configuration = [vaultUrl: 'https://144.22.219.26',  vaultCredentialId: 'jenkins_approle', engineVersion: 2]

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
                withVault([configuration: configuration, vaultSecrets: secrets]) {
                    script {
                        def appimage = docker.build registry + ":$BUILD_NUMBER", "--build-arg var_username=${env.USERNAME} --build-arg var_password=${env.PASSWORD}"
                        docker.withRegistry( '' , registryCredential ) {
                            appimage.push()
                            appimage.push('latest')
                        }
                    }
                }
            }
        }

    }
}
