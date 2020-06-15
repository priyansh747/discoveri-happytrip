pipeline {
    agent none
	parameters { 
	booleanParam(name: 'Execute_Sonar', defaultValue: false, description: '')
	booleanParam(name: 'Deploy', defaultValue: true, description: '')
	choice choices: ['Regular', 'Detailed'], description: '', name: 'Notification_Type'
	}
    stages{
        stage ('Build'){
			agent any
			tools {
				jdk 'jdk8'
				maven 'apache-maven-3.6.1'
			}
			steps{
				notify('Initiating Build Stage')
				powershell 'java -version'
				powershell 'mvn -version'
				powershell 'mvn clean package'
				notify('Completed Build Stage')
			}
		}
        stage ('Sonar') {
            agent any
			tools {
				jdk 'jdk8'
				maven 'apache-maven-3.6.1'
			}
			when {
                expression { params.Execute_Sonar == true }
            }
            steps {
                notify('Initiating Sonar Stage')
				withSonarQubeEnv('sonar6.2') {
					powershell 'mvn sonar:sonar'
				}
		notify('Completed Sonar Stage')
            }
        }
		stage('Archive') {
			agent any
			steps {
				notify('Initiating Archive Stage')
				archiveArtifacts artifacts: '**/*.war'
				notify('Completed Archive Stage')
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
			notify('Initiating Deploy Stage')
			deploy adapters: [tomcat7(credentialsId: 'cc6538f6-9343-4acc-b3fd-1309b39ce983', path: '', url: 'http://localhost:8085')], contextPath: '/happytrip', war: '**/*.war'
			notify('Completed Deploy Stage')
			}
		}
    }
	post {
		always {
			emailext attachLog: true, body: '''$PROJECT_NAME - Build # $BUILD_NUMBER - $BUILD_STATUS:
			Check console output at $BUILD_URL to view the results.''', subject: '$PROJECT_NAME - Build # $BUILD_NUMBER - $BUILD_STATUS!', to: 'prabhav@pratian.com'
		}
	}
}

def notify(status){
	emailext (
		subject: "STARTED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
		body: """<p>STARTED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]':</p>
		<p>Check console output at &QUOT;<a href='${env.BUILD_URL}'>${env.JOB_NAME} [${env.BUILD_NUMBER}]</a>&QUOT;</p>""",
		recipientProviders: [[$class: 'DevelopersRecipientProvider']]
    )
}
