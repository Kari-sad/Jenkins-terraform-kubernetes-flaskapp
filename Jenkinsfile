pipeline {
		agent any	
		stages {
			stage('checkout SCM '){
				steps {
					checkout scm
				}
			}
			stage('terraform init'){
				steps{
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