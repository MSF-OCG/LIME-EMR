import groovy.json.JsonSlurper
import groovy.json.JsonOutput

/**
 * Disables frontend modules in an assembled SPA build.
 *
 * A module is declared in two places that must stay in sync:
 *   - importmap.json      ("imports")  -> where the app-shell loads the bundle from
 *   - routes.registry.json ("routes")  -> the app's pages and extensions
 *
 * Removing a module from the importmap alone leaves its extensions registered against
 * slots such as patient-chart-dashboard-slot. The app-shell then retries resolving a
 * package that the importmap cannot supply, logging
 *   "Could not find the package <name> defined in the current importmap"
 * in an unbounded loop until the browser tab runs out of memory and crashes. Both files
 * are therefore stripped together.
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

def frontendDir = "${project.build.directory}/${project.artifactId}-${project.version}/distro/binaries/openmrs/frontend"

// 'modulesToRemove' is passed as a bound property from the gmavenplus-plugin <properties> configuration
def modulesToRemoveRaw = modulesToRemove ?: ""
if (modulesToRemoveRaw.trim().isEmpty()) {
    log.info("No modules to remove. Set the 'modulesToRemove' property in the pom.xml plugin configuration.")
    return
}

def requestedModules = modulesToRemoveRaw.split(",").collect { it.trim() }.findAll { !it.isEmpty() }
log.info("Modules requested for removal: ${requestedModules}")

// Find the key matching a requested module name.
// A fully qualified name like "@madiro/esm-mental-health-app" matches exactly; a short
// name like "esm-mental-health-app" matches any scope.
def findMatchingKey = { Set keys, String moduleName ->
    keys.find { key ->
        if (moduleName.startsWith("@")) {
            key == moduleName
        } else {
            def shortKey = key.contains("/") ? key.substring(key.lastIndexOf("/") + 1) : key
            shortKey == moduleName
        }
    }
}

// nginx would otherwise keep serving pre-compressed copies written before this edit,
// which still contain the removed modules.
def discardStaleVariants = { File jsonFile ->
    ["br", "gz"].each { ext ->
        def variant = new File("${jsonFile.path}.${ext}")
        if (variant.exists() && variant.delete()) {
            log.info("Discarded stale ${variant.name}")
        }
    }
}

def slurper = new JsonSlurper()
def removedByFile = [:]

// fileName -> the top-level key holding the module map
[("importmap.json"): "imports", ("routes.registry.json"): "routes"].each { fileName, mapKey ->
    def jsonFile = new File("${frontendDir}/${fileName}")
    if (!jsonFile.exists()) {
        log.warn("${fileName} not found at: ${jsonFile.path}")
        return
    }

    def json = slurper.parse(jsonFile)
    def moduleMap = json[mapKey]
    if (moduleMap == null) {
        log.warn("No '${mapKey}' entry in ${fileName}; skipping")
        return
    }

    def removed = []
    def notFound = []

    requestedModules.each { moduleName ->
        def matchingKey = findMatchingKey(moduleMap.keySet(), moduleName)
        if (matchingKey) {
            moduleMap.remove(matchingKey)
            removed << matchingKey
            log.info("Removed ${matchingKey} from ${fileName}")
        } else {
            notFound << moduleName
        }
    }

    jsonFile.text = JsonOutput.prettyPrint(JsonOutput.toJson(json))
    discardStaleVariants(jsonFile)
    removedByFile[fileName] = removed

    log.info("Updated ${fileName} (${moduleMap.size()} entries remain)")
    if (notFound) {
        log.warn("Not present in ${fileName}: ${notFound.join(', ')}")
    }
}

// A module left in routes.registry.json without an importmap entry is the crash described
// above, so fail the build rather than shipping it.
def importmapFile = new File("${frontendDir}/importmap.json")
def routesFile = new File("${frontendDir}/routes.registry.json")
if (importmapFile.exists() && routesFile.exists()) {
    def imports = slurper.parse(importmapFile).imports ?: [:]
    def routes = slurper.parse(routesFile).routes ?: [:]
    def orphans = routes.keySet().findAll { !imports.containsKey(it) }
    if (orphans) {
        throw new RuntimeException(
            "Frontend assembly is inconsistent: ${orphans.join(', ')} " +
            "declared in routes.registry.json but missing from importmap.json. " +
            "The app-shell would retry loading these forever and crash the patient chart.")
    }
    log.info("Verified importmap.json and routes.registry.json agree (${imports.size()} modules)")
}

def totalRemoved = removedByFile.values().flatten().unique()
if (totalRemoved) {
    log.info("Disabled ${totalRemoved.size()} module(s): ${totalRemoved.join(', ')}")
}
