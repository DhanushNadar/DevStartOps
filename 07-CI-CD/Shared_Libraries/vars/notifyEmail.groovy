// Notify email on build success or failure
// post {
//         success {
//             script {
//                 notifyEmail('Wanderlust', 'SUCCESS', 'emai_id')
//             }
//         }
//         failure {
//             script {
//                 notifyEmail('Wanderlust', 'FAILURE', 'email_id')
//             }
//         }
////////////////////////////////////////////////////////////


def call(String projectName, String buildStatus, String recipient) {
    // Set subject based on build status
    def subject = "${projectName} Application build ${buildStatus == 'SUCCESS' ? 'updated and deployed' : 'failed'} - '${currentBuild.result}'"

    // Set body with dynamic background color based on build status
    def body = """
        <html>
        <body>
            <div style="background-color: #FFA07A; padding: 10px; margin-bottom: 10px;">
                <p style="color: black; font-weight: bold;">Project: ${projectName}</p>
            </div>
            <div style="background-color: ${buildStatus == 'SUCCESS' ? '#90EE90' : '#FF6347'}; padding: 10px; margin-bottom: 10px;">
                <p style="color: black; font-weight: bold;">Build Number: ${env.BUILD_NUMBER}</p>
            </div>
            <div style="background-color: #87CEEB; padding: 10px; margin-bottom: 10px;">
                <p style="color: black; font-weight: bold;">URL: ${env.BUILD_URL}</p>
            </div>
        </body>
        </html>
    """

    // Send email using Jenkins' emailext plugin
    emailext(
        attachLog: true,
        from: '3701dhanushsvjc@gmail.com',
        to: recipient,
        subject: subject,
        body: body,
        mimeType: 'text/html'
    )
}
