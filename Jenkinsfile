pipeline {
  agent any

  stages {
      stage('Build Artifact') {
            steps {
              sh "mvn clean package -DskipTests=true"// new build again
              archive 'target/*.jar' 
            }
        }   
    }
}