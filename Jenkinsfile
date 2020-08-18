pipeline{
  triggers {
  pollSCM '* * * * *'
  }
  stages{
    stage('Build'){
      steps{
             powershell label: '', script: '''mvn clean package'''  
      }
    }
  }}
