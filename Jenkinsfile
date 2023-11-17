pipeline {
  agent any

  stages {
      stage('Build Artifact') {
            steps {
              sh "mvn clean package -DskipTests=true"// new build again
              archive 'target/*.jar' 
            }
        } 

      stage('Unit Test') {
            steps {
              sh "mvn test"
            }
            post{
              always{
                junit 'target/surefire-reports*.xml'
                joco execPattern: 'target/joco.exec'
              }
            }
        }     
    }
}