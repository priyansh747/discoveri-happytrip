pipeline{
  agent any
  triggers {
  pollSCM '* * * * *'
  }
  stages {
        stage('Build') {
            tools {
                jdk 'jdk8'
            }
            steps {
                echo "Build Project"
                withSonarQubeEnv('sonar') {
                    powershell label: '', script: 'mvn package -f C:/Program Files (x86)/Jenkins/workspace/happy-pipe/pom.xml sonar:sonar'
                }
                
            }
        }
    }
    post {
        always {
                archiveArtifacts artifacts: '**/*.war', followSymlinks: false
                deploy adapters: [tomcat7(credentialsId: 'tomcat7', path: '', url: 'http://localhost:8081/')], contextPath: 'happytrip-new', onFailure: false, war: '**/*.war'
        }
    }
}
