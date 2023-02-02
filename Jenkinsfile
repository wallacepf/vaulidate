def secrets = [
  [path: 'secrets/vault-poc', engineVersion: 2, secretValues: [
    [envVar: 'USERNAME', vaultKey: 'username'],
    [envVar: 'PASSWORD', vaultKey: 'password']]],
]
def configuration = [vaultUrl: 'https://144.22.219.26',  vaultCredentialId: 'jenkins_approle', engineVersion: 2]


podTemplate(yaml: '''
    apiVersion: v1
    kind: Pod
    spec:
      containers:
      - name: golang
        image: golang:1.17-alpine
        command:
        - sleep
        args:
        - 99d
      - name: kaniko
        image: gcr.io/kaniko-project/executor:debug
        command:
        - sleep
        args:
        - 9999999
        volumeMounts:
        - name: kaniko-secret
          mountPath: /kaniko/.docker
      restartPolicy: Never
      volumes:
      - name: kaniko-secret
        secret:
            secretName: dockercreds
            items:
            - key: .dockerconfigjson
              path: config.json
''') {
    node(POD_LABEL) {
        stage('Get Vaulidate Project') {
            git url: 'https://github.com/wallacepf/vaulidate.git', branch: 'main'
            container('golang') {
                stage('Build Vaulidate') {
                    sh 'go mod tidy'
                    sh 'go build'
                }
            }
        }
        stage('Build Vaulidate Docker Image') {
            environment{
                registry = "wallacepf/vaulidate"
            }
            withVault([configuration: configuration, vaultSecrets: secrets]) {
                container('kaniko') {
                    stage ('Building Project...') {
                        sh '/kaniko/executor --context `pwd` --destination \"${env.registry}\":\"${env.BUILD_NUMBER}\" --build-arg var_username=\"${env.USERNAME}\" --build-arg var_password=\"${env.PASSWORD}\"'
                    }
                }
            }
        }
    }
}



// pipeline {
//     agent any
//     tools {
//         go 'go1.17'
//     }
//     environment {
//         CGO_ENABLED = 0 
//         // GOPATH = "${JENKINS_HOME}/jobs/${JOB_NAME}/builds/${BUILD_ID}"
//         registry = "wallacepf/vaulidate"
//     }
//     stages {        
//         stage('Pre Test') {
//             steps {
//                 echo 'Installing dependencies'
//                 sh 'go version'
//             }
//         }

//         stage('Build') {
//             steps {
//                 echo 'Compiling and building'
//                 echo 'Tidying'
//                 sh 'go mod tidy'
//                 echo 'Building'
//                 sh 'go build'
//             }
//         }

//         stage('Publish') {
//             // agent {
//             //     docker {
//             //         image 'docker:latest'
//             //         reuseNode true
//             //     }
//             // }
//             environment {
//                 registryCredential = 'dockerhub'
//             }
//             steps {
//                 withVault([configuration: configuration, vaultSecrets: secrets]) {
//                     script {
//                         docker.withTool('docker') {
//                             def appimage = docker.build registry + ":$BUILD_NUMBER", "--build-arg var_username=${env.USERNAME} --build-arg var_password=${env.PASSWORD} ."
                        
//                             docker.withRegistry( '' , registryCredential ) {
//                                 appimage.push()
//                                 appimage.push('latest')
//                             }
//                         }
//                     }
//                 }
//             }
//         }

//     }
// }
