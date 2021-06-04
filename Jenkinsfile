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
            //ansiblePlaybook credentialsId: 'Ansible', disableHostKeyChecking: true, installation: 'Ansible', inventory: '/etc/ansible/hosts', playbook: 'installation.yml'
              ansiblePlaybook become: true, credentialsId: 'ansible', disableHostKeyChecking: true, installation: 'Ansible', inventory: '/etc/ansible/hosts', playbook: 'installation.yml'
                }
            }
           
        }
        
        stage('Gmail'){
	     steps
	         {
	     mail to: 'pitchunath123@gmail.com',subject: "Job ${JOB_NAME} (${BUILD_NUMBER}) ",body: "Hi Team, \n\n Please go to ${BUILD_URL} for more details and verify the cause for the build failure. "
	     
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
         unstable {  
             echo 'This will run only if the run was marked as unstable'  
         }  
         changed {  
             echo 'This will run only if the state of the Pipeline has changed'  
             echo 'For example, if the Pipeline was previously failing but is now successful'  
         }  
     }  
    
}
