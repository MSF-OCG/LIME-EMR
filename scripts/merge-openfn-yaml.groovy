@Grab(group='org.yaml', module='snakeyaml', version='2.2')
import org.yaml.snakeyaml.DumperOptions
import org.yaml.snakeyaml.LoaderOptions
import org.yaml.snakeyaml.Yaml
import org.yaml.snakeyaml.constructor.SafeConstructor
import org.yaml.snakeyaml.representer.Representer
import org.yaml.snakeyaml.nodes.Tag
import org.yaml.snakeyaml.nodes.Node

def targetDir = "${project.build.directory}/${project.artifactId}-${project.version}/distro/configs/openfn"
def outputFile = new File("${targetDir}/openfn-project.yaml")

def loaderOptions = new LoaderOptions()
def yaml = new Yaml(loaderOptions)

def mergedYaml = [:]

new File(targetDir).eachFileMatch(~/.+\.yaml$/) { file ->
    file.withInputStream { stream ->
        def yamlContent = yaml.load(stream)
        if (yamlContent instanceof Map) {
            yamlContent.each { key, value ->
                if (mergedYaml.containsKey(key) && mergedYaml[key] instanceof Map && value instanceof Map) {
                    mergedYaml[key] += value
                } else {
                    mergedYaml[key] = value
                }
            }
        }
    }
}

def dumperOptions = new DumperOptions()
dumperOptions.setPrettyFlow(true)
dumperOptions.setSplitLines(false)
dumperOptions.setDefaultFlowStyle(DumperOptions.FlowStyle.BLOCK)


class CustomRepresenter extends Representer {
    CustomRepresenter(DumperOptions options) {
        super(options)
    }

    @Override
    protected Node representScalar(Tag tag, String value, DumperOptions.ScalarStyle style) {
        if (value.contains("\n")) {
            value = value.replaceAll(/\r|\n/, ' ')
            return super.representScalar(tag, value, style)
        } else {
            return super.representScalar(tag, value, style)
        }
    }
}

def representer = new CustomRepresenter(dumperOptions)
def outputYaml = new Yaml(representer, dumperOptions)


outputFile.withWriter { writer ->
    outputYaml.dump(mergedYaml, writer)
}

log.info("Merged OpenFn YAML files into ${outputFile.name}")
