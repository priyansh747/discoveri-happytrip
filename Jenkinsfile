pipeline{
  triggers {
  pollSCM '* * * * *'
  }
  stages{
    stage('Build'){
      
      steps{
             powershell label: '', script: '''mvn clean package'''  
        withSonarQubeEnv(sonar){

}
      }
    }
  }
  post{
    always{
      archiveArtifacts artifacts: '**/*.war', followSymlinks: false
    }
  }
}
