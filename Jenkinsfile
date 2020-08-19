pipeline{
  agent any
  triggers {
  pollSCM '* * * * *'
  }
  parameters {
        booleanParam(name: 'DEPLOY', defaultValue: false, description: 'Do you want to deploy?')
        booleanParam(name: 'CODE_CHECK', defaultValue: false, description: 'Do you want to perform code quality check?')
    }
  stages {
        stage('Build & Sonar') {
            tools {
                jdk 'jdk8'
            }
            when{
                expression { params.CODE_CHECK == true }
            }
            steps {
                echo "Build Project"
                withSonarQubeEnv('sonar') {
                    powershell label: '', script: 'mvn package  sonar:sonar'
                }
                
            }
        }
    stage('Build'){
            tools {
                jdk 'jdk8'
            }
            when{
                expression { params.CODE_CHECK == false }
            }
      steps {
                echo "Build Project"
                withSonarQubeEnv('sonar') {
                    powershell label: '', script: 'mvn package'
                }
      }
    }
    stage('Deploy'){
            when{
                    expression { params.DEPLOY == true }
            }
            steps {
              
              deploy adapters: [tomcat7(credentialsId: 'tomcat7', path: '', url: 'http://localhost:8081/')], contextPath: 'happy-pipe', onFailure: false, war: '**/*.war'
            }
    }
    }
    post {
        always {
                archiveArtifacts artifacts: '**/*.war', followSymlinks: false
          mail bcc: '', body: '''${env.PROJECT_NAME} - Build # ${env.BUILD_NUMBER} - ${env.BUILD_STATUS}:

Check console output at ${env.BUILD_URL} to view the results.''', cc: '', from: '', replyTo: '', subject: '${env.PROJECT_NAME} - Build # ${env.BUILD_NUMBER} - ${env.BUILD_STATUS}!', to: 'priyansh.agarwal@amadeus.com'              
        }
    }
}
