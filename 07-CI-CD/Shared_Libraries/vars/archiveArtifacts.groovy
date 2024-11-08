
// post {
//         success {
//             // Use the shared library function to archive artifacts
//             archiveArtifactsLibrary('*.xml','false')
//         }
//     }
////////////////////////////////////////////////////////////////////

// This function archives artifacts based on the given pattern and configuration
def call(String artifactPattern, boolean followSymlinks) {
    if (!artifactPattern) {
        error("Artifact pattern is required.")
    }
    echo "Archiving artifacts with pattern: ${artifactPattern}"
    archiveArtifacts artifacts: artifactPattern, followSymlinks: followSymlinks
}
