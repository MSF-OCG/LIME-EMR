def distroOpenfnFile = "distro-project.yaml"
def outputFileName = "openfn-project.yaml"
def targetDir = "${project.build.directory}/${project.artifactId}-${project.version}/distro/configs/openfn"
def outputFile = new File("${targetDir}/${outputFileName}")
def stagingOutputFile = new File("${targetDir}/staging_${outputFileName}")

// Clear the output files
outputFile.withWriter { writer ->
    writer.write("")
}

// Get all YAML files in the directory
def allFiles = new File(targetDir).listFiles().findAll { 
    it.name.endsWith('.yaml') && it != outputFile && it != stagingOutputFile 
}

// Separate files into regular and staging groups
def regularFiles = allFiles.findAll { !it.name.toLowerCase().startsWith('staging') }
def stagingFiles = allFiles.findAll { it.name.toLowerCase().startsWith('staging') }

// Add distro file to both regular and staging file lists if it exists
def distroFile = allFiles.find { it.name == distroOpenfnFile }
if (distroFile) {
    if (!regularFiles.contains(distroFile)) {
        regularFiles.add(0, distroFile)
    }
    if (!stagingFiles.contains(distroFile)) {
        stagingFiles.add(0, distroFile)
    }
}

// Function to process and merge files
def mergeFiles = { fileList, targetOutputFile, isStaging ->
    // Sort files: distro-project.yaml first, then alphabetically
    def sortedFiles = fileList.sort { a, b ->
        a.name == "${distroOpenfnFile}" ? -1 : 
        (b.name == "${distroOpenfnFile}" ? 1 : a.name <=> b.name)
    }

    // Append the contents of each YAML file to the target output file
    sortedFiles.each { file ->
        log.info("Processing ${isStaging ? 'staging ' : ''}file: ${file.name}")

        // Add a comment header for each file
        targetOutputFile.append("# ${file.name} OpenFn configuration file\n")
        
        file.withReader { reader ->
            targetOutputFile.append(reader.text + "\n")
        }
    }
}

// Merge regular files
if (regularFiles) {
    mergeFiles(regularFiles, outputFile, false)
    log.info("Appended YAML files into ${outputFile.name}")
} else {
    log.info("No regular files found to merge")
}

// Merge staging files if they exist
def actualStagingFiles = stagingFiles.findAll { it.name.toLowerCase().startsWith('staging') }
if (actualStagingFiles) {
    stagingOutputFile.withWriter { writer ->
        writer.write("")
    }
    mergeFiles(stagingFiles, stagingOutputFile, true)
    log.info("Appended staging YAML files into ${stagingOutputFile.name}")
} else {
    log.info("No staging files found")
}
