#!/usr/bin/env groovy

node {
  try {
    // This doesn't use the buildProject as this project doesn't conform to
    // required norms (e.g. running in Ruby 1.9, non-standard tests).
    def govuk = load '/var/lib/jenkins/groovy_scripts/govuk_jenkinslib.groovy'

    repoName = JOB_NAME.split('/')[0]

    stage("Checkout") {
      govuk.checkoutFromGitHubWithSSH(repoName)
    }

    stage("Clean up workspace") {
      govuk.cleanupGit()
    }

    stage('Configure environment') {
      govuk.setEnvar('RBENV_VERSION', '1.9.3-p550')
    }

    stage('Bundle install') {

      echo 'Bundling'
      govuk.withStatsdTiming("bundle") {
        lock ("bundle_install-$NODE_NAME") {
          // This is a copy of the bundleGem method in the govuk library
          // but we change the `--path` to be in the work directory so that
          // we don't have problems trying to use too-new versions of gems.
          sh("bundle install --path bundles")
        }
      }
    }

    stage('Spec tests') {
      govuk.runRakeTask('spec')
    }

    stage('Integration tests') {
      govuk.runRakeTask('integration')
    }

    if (env.BRANCH_NAME == 'master') {
      stage('Publish Gem to Rubygems') {
        govuk.publishGem(repoName, 'master')
      }
    }
  } catch (e) {
    currentBuild.result = "FAILED"
    step([$class: 'Mailer',
          notifyEveryUnstableBuild: true,
          recipients: 'govuk-ci-notifications@digital.cabinet-office.gov.uk',
          sendToIndividuals: true])
    throw e
  }
}
