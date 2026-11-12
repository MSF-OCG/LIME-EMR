#!/usr/bin/env groovy
/*
  Fails the build when the built app shell shares a library at a version other than the
  one distro/frontend/openmrs-cli/package.json pins in "overrides".
  Run from distro/pom.xml at compile, after Ozone's frontend build (process-resources)
  has written the frontend.

  The app shell hands React, Carbon, i18next and the rest to every ESM as module
  federation singletons, and its openmrs.<hash>.js lists them in
  scopeToSharingDataMapping as {name:"<package>",version:"<version>",...}. Built from an
  unpinned npx install on 2026-11-11, UVL's shell shared @carbon/react 1.120.0 instead
  of 1.119.0, and production lost its Carbon styling (location picker, patient-chart
  left nav) without a single error. This reads the versions the shell actually shares,
  so it also catches a pin that the install did not honour.
*/
import groovy.json.JsonSlurper

def basedir = project.basedir
// "overrides" also pins postcss-selector-parser, a build tool the shell does not share.
def buildOnly = ["postcss-selector-parser"]
def pinned = new JsonSlurper().parse(new File(basedir, "frontend/openmrs-cli/package.json")).overrides
if (!pinned) {
    fail("distro/frontend/openmrs-cli/package.json has no \"overrides\"; nothing pins the libraries the app shell shares.")
}

def frontendDir = new File(project.build.directory,
        "${project.artifactId}-${project.version}/distro/binaries/openmrs/frontend")
def shells = (frontendDir.listFiles() ?: []).findAll {
    it.name ==~ /openmrs\.[0-9a-f]+\.js/ && it.text.contains("scopeToSharingDataMapping")
}
if (shells.size() != 1) {
    fail("Expected one app shell (openmrs.<hash>.js with scopeToSharingDataMapping) in ${frontendDir}, found ${shells*.name}.")
}
def shell = shells[0]

def shared = [:]
(shell.text =~ /\{name:"([^"]+)",version:"([^"]+)"/).each { m -> shared.get(m[1], [] as Set) << m[2] }

def problems = []
pinned.findAll { name, version -> !(name in buildOnly) }.each { name, version ->
    def found = shared[name]
    if (!found) {
        problems << "${name}: pinned to ${version} but not shared by the app shell"
    } else if (found != [version] as Set) {
        problems << "${name}: shared as ${found.join(', ')}, pinned to ${version}"
    }
}
if (problems) {
    fail("The app shell ${shell.name} does not share the pinned versions:\n  " + problems.join("\n  ") +
            "\nThe frontend was not built from the lockfile in distro/frontend/openmrs-cli; see 'Pin the OpenMRS frontend build' in distro/pom.xml.")
}
log.info("Verified: ${shell.name} shares " + pinned.findAll { name, version -> !(name in buildOnly) }.collect { name, version -> "${name} ${version}" }.join(", "))

/*
  The app shell's CSS-module class names are base64 hashes (F+JnE5oCZsS0FV+Mxzn6Mg==).
  postcss-selector-parser 7.2.0 (2026-11-08) escapes them once more than css-loader 5
  expects, so the built selectors read .F\\\+JnE5... and match nothing: Matsapha UAT
  lost the left nav and other framework styling. Escaped class names never need a
  doubled backslash, so any in the shell's CSS means the selectors are broken.
*/
def doubleEscaped = (frontendDir.listFiles() ?: []).findAll {
    it.name.endsWith(".css") && it.text.contains("\\\\")
}
if (doubleEscaped) {
    fail("The app shell CSS has double-escaped selectors, which match no element: " +
            doubleEscaped.collect { "${it.name} (${it.text.count('\\\\')})" }.join(", ") +
            "\nCheck the postcss-selector-parser override in distro/frontend/openmrs-cli/package.json.")
}
log.info("Verified: the app shell CSS has no double-escaped selectors")

def fail(String message) {
    throw new IllegalStateException(message)
}
