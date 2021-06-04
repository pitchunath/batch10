pipeline {
     environment {
    imagename = "pitchunath/casestudy"
    Image = ''
  }
    agent any
    tools { 
        maven 'jenkinsmaven' 
        jdk 'jenkinsjava' 
        dockerTool 'docker'
    }
    stages {     
        stage ('Initialize') {
            steps {
               git 'https://github.com/pitchunath/batch10.git'
            }
        }

        stage ('Build') {
            
            steps {
                script{
                sh 'mvn clean test install'           
                            }
            }
           
        }
        
		stage ('sonar') {
            
            steps {
                script{
                    withCredentials([string(credentialsId: 'sonar', variable: 'token')]) {
                 withSonarQubeEnv('sonar') {
        sh '''mvn sonar:sonar -Dsonar.projectKey=casestudy -Dsonar.host.url=http://35.200.210.161:9000 -Dsonar.login=${token}'''
                
                 }}
                
                }
            }
           
        }
        
		stage ('publish reports') {
            
            steps {
                script{
                
                 
            echo " Publishing HTML report.."
           publishHTML([allowMissing: false, alwaysLinkToLastBuild: true, includes: '**/*.xml', keepAll: true, reportDir: 'target/surefire-reports/', reportFiles: '.xml', reportName: 'Spring Report', reportTitles: ''])
              
                }
            }
           
        }
		
				
        stage ('dockerimageBuild') {
            
            steps {
                script{
                
            
                Image = docker.build(imagename)
               
                }
            }
           
        }
        
        
		 stage ('dockerimagepush') {
            
            steps {
                script{
                
            
                docker.withRegistry('https://registry.hub.docker.com', 'docker') { 
                    
                    Image.push("latest")
                    
                }
               
                }
            }
           
        }
        
         stage ('Ansible configuration') {
            
            steps {
                script{
                  ansiblePlaybook become: true, credentialsId: 'ansible', disableHostKeyChecking: true, installation: 'Ansible', inventory: '/etc/ansible/hosts', playbook: 'installation.yml'
                }
            }
           
        }
             
    }
     post {  
         always {  
             echo 'This will always run'  
         }  
         success {  
             echo 'This will run only if successful'
             mail to: 'pitchunath123@gmail.com',subject: "Congrats!! Job ${JOB_NAME} (${BUILD_NUMBER}) ",body: "Hello, \n\n The BUILD ${BUILD_URL} is Successful You can proceed further. "
         }  
         failure {  
             echo 'This will run only if fails'  
           
	     mail to: 'pitchunath123@gmail.com',subject: "ATTENTION Failure:Job ${JOB_NAME} (${BUILD_NUMBER}) ",body: "Hello, \n\n  ${BUILD_URL} click here to check the cause. "
          
         }  
         
     }  
    
}
