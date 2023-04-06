pipeline {
    agent any
//  parameters {
//   credentials credentialType: 'com.cloudbees.jenkins.plugins.awscredentials.AWSCredentialsImpl', defaultValue: 'AWS_CREDS_AUTOMATION_ACCT', name: 'AWS_AUTOMATION_ACCOUNT_CRED', required: false
// }

    environment {
        PATH = "${PATH}:${getTerraformPath()}"
        AMI_ID="stack-ami-${BUILD_NUMBER}"
        VERSION = "1.0.${BUILD_NUMBER}"
        RUNNER = "Marcus"
    }
    stages{

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
                  slackSend (color: '#FFFF00', message: "TERRAFORM INIT - '${env.RUNNER}': Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
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

                 terraform apply -auto-approve
                 """                          
         }
         }

        //   stage('Build Vulnerability Report'){
        //      steps {
        //          sh """
                 
        //          aws inspector start-assessment-run --assessment-run-name Hardeningrun_'${VERSION}' --assessment-template-arn "arn:aws:inspector:us-east-1:838518434784:target/0-fjdAxFxM/template/0-YbpNdN5U/run/0-t9yfwqY5" --region us-east-1
        //          """  
        //           slackSend (color: '#FFFF00', message: "ENDING DEPLOYMENT: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")                        
        //  }
        //  }
    
    }
}

 def getTerraformPath(){
        def tfHome= tool name: 'terraform-14', type: 'terraform'
        return tfHome
    }

//  def getAnsiblePath(){
//         def AnsibleHome= tool name: 'Ansible', type: 'org.jenkinsci.plugins.ansible.AnsibleInstallation'
//         return AnsibleHome
//     }

// def getPackerPath(){
//        def PackerHome= tool name: 'Packer', type: 'biz.neustar.jenkins.plugins.packer.PackerInstallation'
//     }