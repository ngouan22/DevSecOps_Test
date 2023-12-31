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

        stage('build && SonarQube analysis') {
            steps {
                withSonarQubeEnv('SonarQube') {
              sh 'mvn verify sonar:sonar \
              -Dsonar.organization=azuredevopsorganisation \
              -Dsonar.projectKey=azuredevopsorganisation_devsecops'
                }
            }
        }
      stage("Quality Gate") {
            steps {
                timeout(time: 2, unit: 'MINUTES') {
                    // Parameter indicates whether to set pipeline to UNSTABLE if Quality Gate fails
                    // true = set pipeline to UNSTABLE, false = don't
                    waitForQualityGate abortPipeline: true
                }
            }
        }

      stage('Vulnerability Scan - Docker'){
           steps{
            parallel(
              "Trivy Scan": {
              sh "bash trivy.sh"
            },
              "Dependency Check ": {
              sh "mvn dependency-check:check"
            },
            "OPA Conftest":{
	        		sh ' docker run --rm -v $(pwd):/project openpolicyagent/conftest test --policy dockerfile-security.rego Dockerfile'
	       		}
            )
      }
      }

      /* stage('Vulnerability Scan - Docker'){

            steps{
              sh "mvn dependency-check:check"
            }

              post{
                  always{
                    dependencyCheckPublisher pattern: 'target/dependency-check-report.xml'
                  }
              }
      } */


      /* stage ('Docker Build and Push'){
        steps{
          withDockerRegistry([credentialsId: 'docker_hub', url: '']){
          sh 'printenv'
          sh 'docker build -t geektecknology/devsecopsapp:""$GIT_COMMIT"" .'
          sh 'docker push geektecknology/devsecopsapp:""$GIT_COMMIT"" '
        }
        }
      } */

      /* stage ('Deploy To Kubernetes'){
        steps{
          withKubeConfig([credentialsId: 'kubeconfig']){
          sh "sed -i 's#replace#geektecknology/devsecopsapp:${GIT_COMMIT}#g' k8s_deployment_service.yaml"
          sh 'kubectl apply -f k8s_deployment_service.yaml '
        }
        }
      } */

      /* stage('Remove Unsed docker Images') {
            steps {
              sh 'docker rmi geektecknology/devsecopsapp:""$GIT_COMMIT""'    
            }
        }
        */
    }

    }