pipeline {

        tools{
        maven 'mymaven'
    }

    agent any

    environment {
        DOCKER_REGISTRY = 'https://index.docker.io/v1/'
        DOCKER_IMAGE = 'reshmastani382/abcimage'
    }
    
    stages {
        stage('Checkout') {
            steps {
                // Checkout the code from the repository
                 git branch: 'main', url: ' https://github.com/reshma-stani/pg_project.git '
            }
        }
        stage('Compile') {
            steps {
                // Compile the Maven project
                sh 'mvn compile'
            }
        }
        stage('Test') {
            steps {
                // Run Maven tests
                sh 'mvn test'
            }
        }
        stage('Package') {
            steps {
                // Clean and package the Maven project
                sh 'mvn clean package'
            }
        }


         stage('Build Image'){
            steps{
            
            // Copy the WAR file to the webapps directory in the container
            // sh 'cp /var/lib/jenkins/workspace/Industry_project/target/ABCtechnologies-1.0.war abc_tech.war'
                sh "docker build -t ${DOCKER_IMAGE}:${BUILD_NUMBER} ."
            }
        }
        stage('Push DockerImage'){
            steps{  
               // withDockerRegistery([ credentialsId: "dockerhub", url: ""])
               withDockerRegistry(credentialsId: 'f80a6223-95e8-4a88-a9af-362d5c4a129c', url: DOCKER_REGISTRY) 
               {
                    sh "docker push ${DOCKER_IMAGE}:${BUILD_NUMBER}"
                }
            }
        }
            stage('Run Docker Container') {
            steps {
                script {
                    docker.image("${DOCKER_IMAGE}:${BUILD_NUMBER}").run("-p 8079:8080") 
                    {
                        // Any additional setup or commands to run inside the Docker container
                        sh 'ls -la'
                        sh 'echo "Docker container is running"'
                    }
                }
            }
        }
  //              stage('Deploy Artifacts on Kubernetes') {
   //                 steps {
                   //  Ansible playbook to deploy artifacts on Kubernetes
  //                    sh 'ansible-playbook deploy_kubernetes.yml'
    //            }
      //  }          
        
    }        
}
