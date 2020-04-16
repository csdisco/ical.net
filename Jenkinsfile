def releasableBranch = '(?:origin/)?(?:(?:master)|(?:release\\d*))'
def buildVersion = ''

pipeline {
    options {
        timestamps()
        ansiColor 'xterm'
    }

    agent {
        node {
            label 'windows && docker'
        }
    }

    environment {
        BUILD_DEBUG = 1
    }

    stages {

        stage('Checkout') {
            steps {
                cleanWs()
                checkout scm
                script {
                    buildVersion = '0.0.${env.BUILD_NUMBER}'
                    if (releasableBranch) {
                        currentBuild.description = String.format("Build, Validate, and Release %s", version)
                    }
                    else {
                        currentBuild.description = String.format("Build & Validate %s", version)
                    }
                }
            }
        }

        stage('Build') {
            steps {
                dir('net-core') {
                    powershell '.\\build.ps1 -version ${buildVersion}'
                }
            }
        }

        stage('Test') {
            steps {
                dir('net-core') {
                    powershell '.\\test.ps1'
                }
            }
        }

        stage('Publish') {
            // when {
            //     beforeAgent true
            //     // expression { env.BRANCH_NAME ==~ releasableBranch }
            // }
            steps {
                // Build will already do the package, so we only need to upload that.

                script {
                    def server = Artifactory.server('DISCO')
                    def spec = """\
                    {
                        "files": [{
                            "pattern": "net-core/Ical.Net/nupkgs/*.nupkg",
                            "target": "nuget-local"
                        }]
                    }
                    """.stripIndent()
                    def buildInfo = server.upload(spec)
                    server.publishBuildInfo(buildInfo)
                }
            }
        }
    }
}
