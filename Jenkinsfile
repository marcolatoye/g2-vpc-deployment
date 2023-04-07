pipeline {
    agent any
//  parameters {
//   credentials credentialType: 'com.cloudbees.jenkins.plugins.awscredentials.AWSCredentialsImpl', defaultValue: 'AWS_CREDS_AUTOMATION_ACCT', name: 'AWS_AUTOMATION_ACCOUNT_CRED', required: false
// }

    environment {
        PATH = "${PATH}:${getTerraformPath()}"
        VERSION = "1.0.${BUILD_NUMBER}"
        RUNNER = "Marcus"
    }

    stages{

        stage ('Sonarcube Scan') {
            steps {
                slackSend (color: '#FFFF00', message: "STARTING SONARQUBE SCAN FOR G2 EC2  - '${env.RUNNER}': Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
                script {
                scannerHome = tool 'sonarqube'
                }
                withCredentials([string(credentialsId: 'SONAR_TOKEN', variable: 'SONAR_TOKEN')]){
                withSonarQubeEnv('SonarQubeScanner') {
                sh " ${scannerHome}/bin/sonar-scanner \
                -Dsonar.projectKey=CliXX-App-Marcus   \
                -Dsonar.login=${SONAR_TOKEN} "
                        }
                    }
            }
        }

        stage('Quality Gate') {
            steps {
              //slackSend (color: '#FFFF00', message: "WAITING FOR QUALITY GATE REPORT FOR G2 - '${env.RUNNER}': Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
                timeout(time: 3, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
            }
            }
        }


         stage('Initial Stage') {
              steps {
                // slackSend (color: '#FFFF00', message: "STARTING TERRAFORM DEPLOYMENT - '${env.RUNNER}': Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
                script {
                def userInput = input(id: 'confirm', message: 'Start Pipeline?', parameters: [ [$class: 'BooleanParameterDefinition', defaultValue: false, description: 'Start Pipeline', name: 'confirm'] ])
             }
           }
        }

        stage('Terraform init'){
             steps {
                  //slackSend (color: '#FFFF00', message: "TERRAFORM INIT - '${env.RUNNER}': Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
                 sh """

                 terraform init -upgrade 
                 """                  
         }
         }

        stage('Terraform Plan'){
             steps {
                // slackSend (color: '#FFFF00', message: "STARTING TERRAFORM PLAN - '${env.RUNNER}': Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
                 sh """

                 terraform plan -out=tfplan -input=false
                 """                          
         }
         }

        stage('Terraform Apply or Destroy'){
             steps {
                //  slackSend (color: '#FFFF00', message: "STARTING INFRASTRUCTURE BUILD AND VULNERABILITY SCAN - '${env.RUNNER}': Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
                 sh """

                 terraform destroy -auto-approve
                 """                          
         }
         }

        //   stage('Build Vulnerability Report'){
        //      steps {
        //          sh """
                 
        //          aws inspector start-assessment-run --assessment-run-name Hardeningrun_'${VERSION}' --assessment-template-arn "arn:aws:inspector:us-east-1:838518434784:target/0-lZCXDPw9/template/0-8VwBwXk9" --region us-east-1
        //          """  
        //           // slackSend (color: '#FFFF00', message: "ENDING DEPLOYMENT: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")                        
        //  }
        //  }
    
    }
}

def getSonarPath(){
        def SonarHome= tool name: 'sonarqube', type: 'hudson.plugins.sonar.SonarRunnerInstallation'
        return SonarHome
    }

def getTerraformPath(){
        def tfHome= tool name: 'terraform-14', type: 'terraform'
        return tfHome
    }
