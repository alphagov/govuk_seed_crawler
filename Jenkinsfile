#!/usr/bin/env groovy

library("govuk")

node {
  try {
    // This doesn't use the buildProject as this project doesn't conform to
    // required norms (e.g. running in Ruby 1.9, non-standard tests).

    repoName = JOB_NAME.split('/')[0]

    stage("Checkout") {
      govuk.checkoutFromGitHubWithSSH(repoName)
    }

    stage("Clean up workspace") {
      govuk.cleanupGit()
    }

    stage('Bundle install') {
      govuk.bundleGem()
    }

    stage('Run tests') {
      govuk.runRakeTask('default')
    }

    if (env.BRANCH_NAME == 'main') {
      stage('Publish Gem to Rubygems') {
        govuk.publishGem(repoName, repoName, 'main')
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
