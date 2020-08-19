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
              mail bcc: '', body: 'JENKINS NOTIFICATION', cc: '', from: 'no-reply@jenkins.com', replyTo: '', subject: 'BUILD COMPLETE', to: 'priyanshagarwal1998@gmail.com'
                
        }
    }
}
