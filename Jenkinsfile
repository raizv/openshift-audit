try {
  
  stage('Checkout') {
    node {
      sh "oc project ${env.PROJECT_NAME}"
      checkout scm
    }
  }

  /*
   * Run the openshift-audit app in a standalone pod for each environment.
   */
  stage('Run App') {
    parallel(
      'Dev':{
        test(
          environment: 'dev'
        )
      },
      'Prod':{
        test(
          environment: 'prod'
        )
      }
    )
  }

  currentBuild.result = 'SUCCESS'
}
catch (org.jenkinsci.plugins.workflow.steps.FlowInterruptedException flowError) {
  currentBuild.result = 'ABORTED'
}
catch (err) {
  currentBuild.result = 'FAILURE'
  throw err
}
finally {
  if (currentBuild.result == 'SUCCESS') {
  }
}

def test(Map attrs) {
  node {
    ansiColor('xterm') {
      sh("./oc-run.sh ${attrs.environment}")
    }
  }
}
