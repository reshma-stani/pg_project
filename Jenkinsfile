pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                // Checkout code from Git repository
                git 'https://github.com/reshma-stani/pg_project.git'
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
                // Run tests using Maven
                sh 'mvn test'
            }
        }
        stage('Package') {
            steps {
                // Package the Maven project
                sh 'mvn package'
            }
        }
    }
}