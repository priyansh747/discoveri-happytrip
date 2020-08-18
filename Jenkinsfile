pipeline{
  agent any
  triggers {
  pollSCM '* * * * *'
  }
  stages{
    stage('Build'){
      steps{
             powershell label: '', script: '''mvn package -f happy-pipe\\pom.xml'''  
      }
    }
  }
}
