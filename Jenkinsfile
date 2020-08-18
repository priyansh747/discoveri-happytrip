pipeline{
  triggers {
  pollSCM '* * * * *'
  }
  withSonarQubeEnv {
    // some block
}
  stages{
    stage('Build'){
      input {
                message "Should we perform code analysis with sonar"
                ok "Yes"
                submitter "alice,bob"
                powershell label: '', script: '''sonar : sonar'''
            }
      input{
         message "Should we deploy"
        ok "yes"
        submitter "alice,bob"
        deploy adapters: [tomcat7(credentialsId: 'tomcat7', path: '', url: 'http://localhost:8081/')], contextPath: 'happytrip', onFailure: false, war: '**/*.war'
      }
      steps{
             powershell label: '', script: '''mvn clean package'''             
      }
    }
  }
  post{
    always{
      archiveArtifacts artifacts: '**/*.war', followSymlinks: false
    }
  }
}
