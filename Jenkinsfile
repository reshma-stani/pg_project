pipeline {

        tools{
        maven 'mymaven'
    }

        environment {
             DOCKERHUB_CREDENTIALS=credentials('dockerhub-token')
                }
    agent any
    
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
            // Delete all unused Docker images
               sh 'docker image prune -a --force'
            // Copy the WAR file to the webapps directory in the container
               sh 'cp /var/lib/jenkins/workspace/Industry_project/target/ABCtechnologies-1.0.war abc_tech.war'
               sh 'docker build -t abcimage:$BUILD_NUMBER .'
            }
        }
        stage('Push DockerImage'){
            steps{
               // withDockerRegistery([ credentialsId: "dockerhub", url: ""])
               withDockerRegistry(credentialsId: 'f80a6223-95e8-4a88-a9af-362d5c4a129c', url: 'https://hub.docker.com/') 
                {
                    sh 'docker push reshmastani382/abcimage:$BUILD_NUMBER'
            }
          }
            
                
        }
    }
}
