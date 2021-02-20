pipeline {
		agent any
		//if you want to set trigger 
		//riggers {
		//	pollSCM "* * * * *"
        }
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