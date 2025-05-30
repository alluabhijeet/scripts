# Download and install GitHub CLI
RUN curl -fsSL https://github.com/cli/cli/releases/download/v2.34.0/gh_2.34.0_linux_amd64.tar.gz -o gh.tar.gz \
    && tar -xvzf gh.tar.gz \
    && mv gh_*/bin/gh /usr/local/bin/gh \
    && rm -rf gh.tar.gz gh_*


pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                // Checkout the branch associated with the Jenkins job
                checkout scm
            }
        }

        stage('Merge Main') {
            steps {
                script {
                    // Fetch the latest changes from the repository
                    sh 'git fetch origin'

                    // Get the current branch name
                    def currentBranch = sh(script: 'git rev-parse --abbrev-ref HEAD', returnStdout: true).trim()

                    // Attempt to merge the latest changes from the main branch into the current branch
                    def mergeStatus = sh(script: "git merge origin/main", returnStatus: true)

                    // Check if the merge was successful (status 0 means successful merge)
                    if (mergeStatus != 0) {
                        error "Merge conflict detected. The build has failed."
                    }

                    // If the merge is successful, commit the changes
                    sh "git commit -am 'Merge latest changes from main into ${currentBranch}'"

                    // Push the merge commit (optional)
                    // sh "git push origin ${currentBranch}"
                }
            }
        }

        stage('Build') {
            steps {
                // Your build steps go here
                sh 'echo "Build step here"'
            }
        }
    }
}
