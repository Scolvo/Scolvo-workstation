pipeline {
    agent any

    options {
        buildDiscarder(logRotator(numToKeepStr:'5'))
        disableConcurrentBuilds()
    }

    stages {
        stage ("Invoke base job") {
            steps {
                build job: '_Base jobs/Base Liquibase script generator', 
									parameters: [
										string(name: 'ORIGINAL_JOB_NAME', value: env.JOB_NAME), 
										string(name: 'PROJECT_GIT_NAME', value: 'workstation'),
										booleanParam(name: 'GENERATE_ANDROID', value: true)
									]
            }
        }
    }
}
