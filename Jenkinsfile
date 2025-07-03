pipeline {
    agent any
    tools {
        maven "MAVEN3.9"
        jdk "JDK17"
    }

    stages {
        stage('Fetch Code')
        {
            steps {
                git branch: 'atom', url: 'https://github.com/hkhcoder/vprofile-project.git'
            }

        }
        stage('Build')
        {
            steps {
                sh 'mvn install -DskipTests'
            }
            post {
                success {
                    echo "Archiving artifacts"
                    archiveArtifacts artifacts: '**/*.war'

                }

            }

        }
        stage('unit Test')
        {
            steps {
                sh 'mvn test'
            }

        }
        stage('Checkstyle Analysis')
        {
            steps {
                sh 'mvn checkstyle:checkstyle'
            }

        }
    }
}
