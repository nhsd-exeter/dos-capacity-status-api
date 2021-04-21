pipeline {
  agent { label 'jenkins-slave' }
  parameters {
    choice(name: 'PROFILE', choices: ['demo', 'live'], description: 'Choose environment to tag artefacts and commit with')
    string(name: 'COMMIT', defaultValue: 'abcd123', description: 'The commit hash of the commit you want to tag')
  }
  options {
    buildDiscarder(logRotator(daysToKeepStr: '7', numToKeepStr: '13'))
    disableConcurrentBuilds()
    parallelsAlwaysFailFast()
    timeout(time: 45, unit: 'MINUTES')
  }
  environment {
    PROFILE = 'dev'
    COMMIT = "${params.COMMIT}"
    ARTEFACTS = 'proxy,api'
    BUILD_TIMESTAMP = "${BUILD_TIMESTAMP}"
  }
  stages {
    stage('Show Configuration') {
      steps {
        script { sh 'make show-configuration' }
      }
    }
    stage('Tag Artefacts') {
      steps {
        script { sh "make tag-images-for-production PROFILE=${params.PROFILE} COMMIT=${COMMIT} ARTEFACTS=${ARTEFACTS} BUILD_TIMESTAMP=${BUILD_TIMESTAMP}" }
      }
    }
    stage('Tag Commit') {
      environment { TAG = sh(returnStdout: true, script: "make project-get-production-tag PROFILE=${params.PROFILE} BUILD_TIMESTAMP=${BUILD_TIMESTAMP}").trim() }
      steps {
        withCredentials([usernamePassword(credentialsId: ‘dehe1’, passwordVariable: ‘GIT_PASSWORD’, usernameVariable: ‘GIT_USERNAME)]) {
          script { sh "make git-tag-create TAG=${TAG} COMMIT=${COMMIT}" }
        }
      }
    }
  }
  post {
    success { sh "make pipeline-send-notification PIPELINE_NAME='DoS Capacity API (Tag)' BUILD_STATUS=${currentBuild.currentResult}" }
    failure { sh "make pipeline-send-notification PIPELINE_NAME='DoS Capacity API (Tag)' BUILD_STATUS=${currentBuild.currentResult}" }
    cleanup { sh 'make clean' }
  }
}
