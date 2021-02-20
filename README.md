# Jenkins pipeline to deploy a flask application to a kubernetes cluster usine terraform. #

VM with Ubuntu 20.04  

### Install Java   ###
    sudo apt update && sudo apt upgrade 
    apt-get install openjdk-8-jdk

**Check java version installed**  

    java -version

**Set JAVA_HOME:**  
 
- Edit .bashrc and add these lines at the end

        export JAVA_HOME=/usr
        export PATH=$JAVA_HOME/bin:$PATH

### Install Jenkins 
 
[https://pkg.jenkins.io/debian-stable/](https://pkg.jenkins.io/debian-stable/)

    wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -  

- Add the following entry in your /etc/apt/sources.list:
    
  `deb https://pkg.jenkins.io/debian-stable binary/ ` 

- Update local package index, then finally install Jenkins: 
 
	    sudo apt-get update  
	    sudo apt-get install jenkins  

**Start Jenkins**  

- You can start the Jenkins service with the command:  
 
 `sudo systemctl start jenkins`  
 
- You can enable the Jenkins service at boot with the command:  
 
 `sudo systemctl enable jenkins`    
 
- You can check the status of the Jenkins service using the command:  
 
   `sudo systemctl status jenkins ` 


**Accessing Jenkins**  

- By default jenkins runs at port 8080, You can access jenkins at

    *http://YOUR-SERVER-PUBLIC-IP:8080*
 
- Unlock Jenkins page will be shown.
 
     `cat /var/lib/jenkins/secrets/initialAdminPassword`
- Copy the key and paste it into unlock jenkins /administrator password     
- Install suggested plugins    
- create new admin user    
- save and finish    
- start jenkins  

### install git ###

    sudo apt update  
    sudo apt install git  


Then set the path to git installer (**/usr/bin/git**) in jenkins Global Tool Configuration   
  
**Configure identity if needed**
   
    git config --global user.name "abc de"   
    git config --global user.email abcde@example.com

### Install docker ###
[Follow link](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-20-04)


> **ERROR:** dial unix /var/run/docker.sock: connect: permission denied  
> **FIX:**  [https://www.digitalocean.com/community/questions/how-to-fix-docker-got-permission-denied-while-trying-to-connect-to-the-docker-daemon-socket](https://www.digitalocean.com/community/questions/how-to-fix-docker-got-permission-denied-while-trying-to-connect-to-the-docker-daemon-socket)
  
    sudo usermod -aG docker ${USER}  
    sudo usermod -aG docker jenkins  
    systemctl restart docker  
    sudo chmod 666 /var/run/docker.sock ---this worked

Install terraform:  
[link to official installation website](https://learn.hashicorp.com/tutorials/terraform/install-cli)  

    curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -  
    sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"  
    sudo apt-get update && sudo apt-get install terraform

**In Jenkins, add these plugins:** 
 
- Docker Pipeline  
- Terraform  

### Install kind and create cluster  ###
[Follow link](https://octopus.com/blog/testing-with-kind)

    curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.10.0/kind-linux-amd64  
    chmod +x ./kind  
    sudo mv ./kind /usr/local/bin  

**Create cluster**

[More about YAML config file for kind cluster](https://kind.sigs.k8s.io/docs/user/configuration/)

    kind create cluster --name app --config kind-config.yaml
This cluster is then made accessible with the configuration stored in the `~/.kube/config` file, created by Kind when the cluster was created. A copy is included in the repo. 

Verify that your cluster exists by listing your kind clusters:
  
`kind get clusters ` 

### Install kubectl ###
[Follow link](https://kubernetes.io/docs/tasks/tools/install-kubectl/#install-using-native-package-management)    
point kubectl to interact with this cluster  

    kubectl cluster-info --context kind-app

From Jenkins create a jenkins pipeline jenkinsfile