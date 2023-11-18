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
                junit 'target/surefire-reports/*.xml'
                jacoco execPattern: 'target/jacoco.exec'
              }
            }
        }
      
      stage ('SonarQube SAST'){
        steps{
         
          sh 'mvn verify sonar:sonar \
              -Dsonar.token=1d0b8c800557a0ac04f7bea24dd4aca2637b4bf3 \
              -Dsonar.host.url=https://sonarcloud.io \
              -Dsonar.organization=azuredevopsorganisation \
              -Dsonar.projectKey=azuredevopsorganisation_devsecops'
        }
      
      }
      

      stage ('Docker Build and Push'){
        steps{
          withDockerRegistry([credentialsId: 'docker_hub', url: '']){
          sh 'printenv'
          sh 'docker build -t geektecknology/devsecopsapp:""$GIT_COMMIT"" .'
          sh 'docker push geektecknology/devsecopsapp:""$GIT_COMMIT"" '
        }
        }
      }

      stage ('Deploy To Kubernetes'){
        steps{
          withKubeConfig([credentialsId: 'kubeconfig']){
          sh "sed -i 's#replace#geektecknology/devsecopsapp:${GIT_COMMIT}#g' k8s_deployment_service.yaml"
          sh 'kubectl apply -f k8s_deployment_service.yaml '
        }
        }
      }

      stage('Remove Unsed docker Images') {
            steps {
              sh 'docker rmi geektecknology/devsecopsapp:""$GIT_COMMIT""'    
            }
        }

    }
}