pipeline {
    agent none
	parameters { 
	booleanParam(name: 'Execute_Sonar', defaultValue: false, description: '')
	booleanParam(name: 'Deploy', defaultValue: true, description: '')
	}
    stages{
        stage ('Build'){
			agent any
			tools {
				jdk 'jdk8'
				maven 'maven-3.6.1'
			}
			steps{
				echo "Building"
				powershell 'java -version'
				powershell 'mvn -version'
				powershell 'mvn clean package'
			}
		}
        stage ('Sonar') {
            agent any
			tools {
				jdk 'jdk8'
				maven 'maven-3.6.1'
			}
			when {
                expression { params.Execute_Sonar == true }
            }
            steps {
                echo "Executing Sonar"
				withSonarQubeEnv('sonar6.2') {
					powershell 'mvn sonar:sonar'
				}
            }
        }
		stage('Archive') {
			agent any
			steps {
				archiveArtifacts artifacts: '**/*.war'
			}	
		}		
		stage ('Approval'){
			agent none
            when {
                expression { params.Deploy == true }
            }            
			steps{
                script {
                        approved = input message: 'Release to production?', ok: 'Yes', submitter: 'pm'
    					if (approved) {
    						withCredentials([usernamePassword(credentialsId: 'privilegedCreds', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
    						echo "Approved"
    					        		}
    					}
    			}
            }
        }
		stage ('Deploy'){
			agent any
            when {
                expression { params.Deploy == true }
            }
			steps{
			echo "Deploying"
			deploy adapters: [tomcat7(credentialsId: 'cc6538f6-9343-4acc-b3fd-1309b39ce983', path: '', url: 'http://172.31.11.5:8085')], 				contextPath: '/happytrip', war: '**/*.war'
			}
		}
    }
}
