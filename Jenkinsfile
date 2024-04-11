pipeline {

        tools{
        maven 'mymaven'
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
    }
}
