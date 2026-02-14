import groovy.json.JsonSlurper
import groovy.json.JsonOutput

/**
 * Removes specified frontend modules from the importmap.json file.
 *
 * Configured via the gmavenplus-plugin <properties> block in the pom.xml:
 *   <property>
 *       <name>modulesToRemove</name>
 *       <value>esm-mental-health-app,esm-nutrition-app</value>
 *   </property>
 *
 * Accepts module names in any of these forms:
 *   - esm-mental-health-app
 *   - @madiro/esm-mental-health-app
 *   - @openmrs/esm-dispensing-app
 */

def importmapPath = "${project.build.directory}/${project.artifactId}-${project.version}/distro/binaries/openmrs/frontend/importmap.json"
def importmapFile = new File(importmapPath)

if (!importmapFile.exists()) {
    log.warn("importmap.json not found at: ${importmapPath}")
    return
}

// 'modulesToRemove' is passed as a bound property from the gmavenplus-plugin <properties> configuration
def modulesToRemoveRaw = modulesToRemove ?: ""
if (modulesToRemoveRaw.trim().isEmpty()) {
    log.info("No modules to remove. Set the 'modulesToRemove' property in the pom.xml plugin configuration.")
    return
}

def modulesToRemove = modulesToRemoveRaw.split(",").collect { it.trim() }.findAll { !it.isEmpty() }
log.info("Modules requested for removal: ${modulesToRemove}")

def slurper = new JsonSlurper()
def importmap = slurper.parse(importmapFile)

def removedModules = []
def notFoundModules = []

modulesToRemove.each { moduleName ->
    // Find the matching key in the imports map.
    // If the user passed a fully qualified name like "@madiro/esm-mental-health-app", match exactly.
    // If the user passed a short name like "esm-mental-health-app", match any key ending with that name.
    def matchingKey = importmap.imports.keySet().find { key ->
        if (moduleName.startsWith("@")) {
            return key == moduleName
        } else {
            // Match the short name: the part after the "/" (or the key itself if no scope)
            def shortKey = key.contains("/") ? key.substring(key.lastIndexOf("/") + 1) : key
            return shortKey == moduleName
        }
    }

    if (matchingKey) {
        importmap.imports.remove(matchingKey)
        removedModules << matchingKey
        log.info("Removed: ${matchingKey}")
    } else {
        notFoundModules << moduleName
        log.warn("Module not found in importmap: ${moduleName}")
    }
}

// Write the updated importmap back with pretty printing
def jsonOutput = JsonOutput.prettyPrint(JsonOutput.toJson(importmap))
importmapFile.text = jsonOutput

log.info("Updated importmap.json written to: ${importmapPath}")
if (removedModules) {
    log.info("Successfully removed ${removedModules.size()} module(s): ${removedModules.join(', ')}")
}
if (notFoundModules) {
    log.warn("Could not find ${notFoundModules.size()} module(s): ${notFoundModules.join(', ')}")
}
