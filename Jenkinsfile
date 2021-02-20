pipeline {
		agent any	
		stages {
			stage('Clean workspace'){
				steps{
					script{
						cleanWs()						
					}
				}
			}
			stage('Cloning our Git'){
				steps {
					checkout scm
					//checkout([$class: 'GitSCM', branches: [[name: '*/master']], extensions: [], gitTool: 'Default', userRemoteConfigs: [[url: 'https://github.com/Kari-sad/Jenkins-terraform-kubernetes-flaskapp']]])
					//script{
					//	git 'https://github.com/Kari-sad/Jenkins-terraform-kubernetes-flaskapp.git' 
					//}		
				}
			}
			stage('terraform init'){
				steps{
					//As we added terraform init folder to gitignore, we will need to initialize each time we clone git repo
					script{
						sh 'terraform init'
					}
				}
			}
			stage('Deploy to kubernetes'){
				steps{
					sh 'terraform apply -auto-approve'
				}
			}
		}
	}