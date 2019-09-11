pipeline {
  environment {
    registry = "romancin/rutorrent-flood"
    repository = "rutorrent-flood"
    withCredentials = 'dockerhub'
    registryCredential = 'dockerhub'
  }
  agent any
  stages {
    stage('Cloning Git Repository') {
      steps {
        git url: 'https://github.com/romancin/rutorrent-flood-docker.git',
            branch: 'develop'
      }
    }
    stage('Building image and pushing it to the registry') {
            steps {
                script {
                    def gitbranch = sh(returnStdout: true, script: 'git rev-parse --abbrev-ref HEAD').trim()
                    def version = readFile('VERSION')
                    def versions = version.split('\\.')
                    def major = gitbranch + '-' + versions[0]
                    def minor = gitbranch + '-' + versions[0] + '.' + versions[1]
                    def patch = gitbranch + '-' + version.trim()
                    docker.withRegistry('', registryCredential) {
                        def image = docker.build registry + ":" + gitbranch
                        image.push()
                        image.push(major)
                        image.push(minor)
                        image.push(patch)
                    }
                }
                script {
                  withCredentials([usernamePassword(credentialsId: 'dockerhub', passwordVariable: 'DOCKERHUB_PASSWORD', usernameVariable: 'DOCKERHUB_USERNAME')]) {
                    docker.image('sheogorath/readme-to-dockerhub').withRun('-v README.md:/data/README.md -e DOCKERHUB_USERNAME=$DOCKERHUB_USERNAME -e DOCKERHUB_PASSWORD=$DOCKERHUB_PASSWORD -e DOCKERHUB_REPO_NAME=$repository') {
                    } 
                  }
                }
                }
            }
    }
 post {
        success {
            telegramSend '[Jenkins] - Pipeline CI-rutorrent-docker $BUILD_URL finalizado con estado :: $BUILD_STATUS'    
        }
    }
}

