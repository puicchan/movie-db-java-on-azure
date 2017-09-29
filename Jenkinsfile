node('container') {
  stage('init') {
    // git clone
    checkout scm
  }

  stage('build web-app') {
    dir('web-app') {
      sh 'mvn clean package'
    }
  }

  stage('build data-app') {
    dir('data-app') {
      sh 'mvn clean package'
    }
  }

  stage('deploy web-app') {
    dir('web-app/target') {
      sh 'cp ../src/main/docker/base/Dockerfile .'
      azureWebAppPublish azureCredentialsId: env.AZURE_CRED_ID, publishType: 'docker',
                         resourceGroup: env.WEB_APP_GROUP, appName: env.WEB_APP_NAME,
                         dockerImageName: "$env.ACR_LOGIN_SERVER/web-app", dockerImageTag: "$(date %Y%m%d%H%M%S)-$env.BUILD_NUMBER",
                         dockerRegistryEndpoint: [url: "http://$env.ACR_LOGIN_SERVER", credentialsId: env.ACR_CRED_ID]
    }
  }

  stage('deploy data-app') {
    dir('data-app/target') {
      sh 'cp ../src/main/docker/base/Dockerfile .'
      withCredentials([usernamePassword(credentialsId: env.ACR_CRED_ID, usernameVariable: 'ACR_USER', passwordVariable: 'ACR_PASSWORD')]) {
        sh 'docker login -u $ACR_USER -p $ACR_PASSWORD http://$ACR_LOGIN_SERVER'
        // build image
        def imageWithTag = "$env.ACR_LOGIN_SERVER/data-app:$(date %Y%m%d%H%M%S)-$env.BUILD_NUMBER"
        def image = docker.build imageWithTag
        // push image
        image.push()
      }
    }
    kubernetesDeploy credentialsType: 'SSH',
                     ssh: [sshServer: env.ACS_SERVER, sshCredentialsId: env.ACS_CRED_ID],
                     dockerCredentials: [[url: "http://$env.ACR_LOGIN_SERVER", credentialsId: env.ACR_CRED_ID]],
                     secretName: env.ACR_LOGIN_SERVER,
                     configs: 'deployment/data-app/deploy.yaml', namespace: env.TARGET_ENV
  }
}
