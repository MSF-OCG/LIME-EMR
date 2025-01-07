def distroOpenfnFile = "distro-project.yaml"
def outputFileName = "openfn-project.yaml"
def targetDir = "${project.build.directory}/${project.artifactId}-${project.version}/distro/configs/openfn"
def outputFile = new File("${targetDir}/${outputFileName}")

outputFile.withWriter { writer ->
    writer.write("")
}

def files = new File(targetDir).listFiles().findAll { it.name.endsWith('.yaml') }
files.sort { it.name == "${distroOpenfnFile}" ? -1 : 0 }

// Append the contents of each YAML file to the output file
files.each { file ->
    if (file != outputFile) {
        // Add a comment header for each file
        outputFile.append("# ${file.name} OpenFn configuration file\n")
    }
    
    file.withReader { reader ->
        outputFile.append(reader.text + "\n")
    }
}

log.info("Appended YAML files into ${outputFile.name}")
