pipeline {
  environment {
    registry = "romancin/rutorrent-flood"
    repository = "rutorrent-flood"
    withCredentials = 'dockerhub'
    registryCredential = 'dockerhub'
    MAXMIND_LICENSE_KEY = credentials('maxmind-license-key')
  }
  agent any
  stages {
    stage('Cloning Git Repository') {
      steps {
        git url: 'https://github.com/romancin/rutorrent-flood-docker.git',
            branch: '$BRANCH_NAME'
      }
    }
    stage('Building image and pushing it to the registry (develop)') {
      when{
        branch 'develop'
        }
      steps {
        script {
          def gitbranch = sh(returnStdout: true, script: 'git rev-parse --abbrev-ref HEAD').trim()
          def version = readFile('VERSION')
          def versions = version.split('\\.')
          def base = gitbranch
          def major = gitbranch + '-' + versions[0]
          def minor = gitbranch + '-' + versions[0] + '.' + versions[1]
          def patch = gitbranch + '-' + version.trim()
          docker.withRegistry('', registryCredential) {
            def image = docker.build("$registry:$gitbranch",  "--build-arg BASE_IMAGE=romancin/rutorrent:develop -f Dockerfile .")
            image.push()
            image.push(base)
            image.push(major)
            image.push(minor)
            image.push(patch)
            }
        }
      }
    }
    stage('Building image and pushing it to the registry (master)') {
      when{
        branch 'master'
        }
      steps {
        script {
          def version = readFile('VERSION')
          def versions = version.split('\\.')
          def base = '0.9.8'
          def major = '0.9.8-' + versions[0]
          def minor = '0.9.8-' + versions[0] + '.' + versions[1]
          def patch = '0.9.8-' + version.trim()
          docker.withRegistry('', registryCredential) {
            def image = docker.build("$registry:latest", "--build-arg BASE_IMAGE=romancin/rutorrent:latest -f Dockerfile .")
            image.push()
            image.push(base)
            image.push(major)
            image.push(minor)
            image.push(patch)
            }
        }
        script {
          withCredentials([usernamePassword(credentialsId: 'dockerhub', passwordVariable: 'DOCKERHUB_PASSWORD', usernameVariable: 'DOCKERHUB_USERNAME')]) {
          docker.image('sheogorath/readme-to-dockerhub').run('-v $PWD:/data -e DOCKERHUB_USERNAME=$DOCKERHUB_USERNAME -e DOCKERHUB_PASSWORD=$DOCKERHUB_PASSWORD -e DOCKERHUB_REPO_NAME=$repository')
          }
        }
      }
    }
  }
  post {
        success {
            telegramSend '[Jenkins] - Pipeline CI-rutorrent-flood-docker $BUILD_URL finalizado con estado :: $BUILD_STATUS'
        }
  }
 }
