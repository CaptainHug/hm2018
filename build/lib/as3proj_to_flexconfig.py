import sys
from time import strftime
import datetime
import time
import xml.etree.ElementTree
from xml.etree.ElementTree import ElementTree, Element, SubElement, Comment, ElementTree

# useful links...
# project reader: https://github.com/fdorg/flashdevelop/blob/c80a257f0b3fbe5f603878bd919112cad0aee9e0/External/Plugins/ProjectManager/Projects/AS3/AS3ProjectReader.cs
# config writer: https://github.com/fdorg/flashdevelop/blob/c80a257f0b3fbe5f603878bd919112cad0aee9e0/External/Tools/FDBuild/Building/AS3/FlexConfigWriter.cs#L56

def readOutputValuesAsDictionary(node):
        dest = {}
        # list of movie options
        for child in node:
                for key in child.attrib:
                        value = child.attrib[key]
                        dest[key] = value            
        return dest

def readOutputValuesAsArray(node, childtag):
        dest = []

        # array of class paths
        for child in node:
                if(child.tag == childtag):
                        dest.append(child.attrib['path'])
        return dest

def printDataStructure(data, depth = 0):
        returnValue = "";
        
        if(type(data) is dict):
                maxlength = 0
                for key, value in data.items():
                        if(len(key) > maxlength):
                                maxlength = len(key)
                              
                for key, value in data.items():
                        returnValue = returnValue + ("\n" + ("\t" * depth) + key + ": " +  (" " * (maxlength - len(key))) + printDataStructure(value, depth + 1))
        elif(type(data) is str or type(data) is int):
                returnValue = ("\t" * depth) + data
        elif(type(data) is list):
                for value in data:
                    returnValue = returnValue + "\n" + ("\t" * depth) + value    
        else:
                return str(data)
        return returnValue

def CheckIfOutputOptionIsValue(option, project, value):
        return option in project["output"] and project["output"][option] == value

def readAS3ProjToProject(filename):
        print("readAS3ProjToProject: %s" % filename)

        # Get the actual Version
        sdkVersion = 4

        # Where are these set ? 
        debugMode = False
        isDesktop = False
        ASC2Mode = False

        root = xml.etree.ElementTree.parse(filename).getroot()

        project = {}
        project["output"] = {}
        project["classpaths"] = {}
        project["build"] = {}

        for child in root:
                if(child.tag == "output"):
                        project["output"] = readOutputValuesAsDictionary(child)
                elif(child.tag == "classpaths"):
                        project["classpaths"] = readOutputValuesAsArray(child, "class")
                elif(child.tag == "build"):
                        project["build"] = readOutputValuesAsDictionary(child)
                elif(child.tag == "libraryPaths"):
                        project["libraryPaths"] = readOutputValuesAsArray(child, "element")
                elif(child.tag == "compileTargets"):
                        project["compileTargets"] = readOutputValuesAsArray(child, "compile")

        project["flex4"] = "True" if sdkVersion >= 4 else "False"
        project["Debug"] = "True" if debugMode else "False"
        project["Mobile"] = "True" if CheckIfOutputOptionIsValue("platform", project, "AIR Mobile") else "False"
        project["Desktop"] = "True" if isDesktop else "False"
        project["ASC2"] = "True" if ASC2Mode else "False"
        
        print(printDataStructure(project))
        return project


def AddDefine(name, value, root):
        defineNode = SubElement(root, "define")
        defineNode.attrib["append"] = "true"
        nameNode = SubElement(defineNode, "name")
        valueNode = SubElement(defineNode, "value")
        nameNode.text = name
        valueNode.text = value

def AddNodeWithText(name, value, root):
        addedNode = SubElement(root, name)
        addedNode.text = value
        
        return addedNode
        
def AddNodeWithAttribute(name, attribute, value, root):
        addedNode = SubElement(root, name)
        addedNode.attrib[attribute] = value

        return addedNode

def CheckIfBuildOptionIsValue(option, project, value):
        return option in project["build"] and project["build"][option] == value

def AddCompilerOptions(compilerNode, project):
        # What is this ? do we need it ? 
        """
        if (options.Locale.Length > 0)
            {
                WriteStartElement("locale");
                    WriteElementString("locale-element", options.Locale);
                WriteEndElement();
            }
        """

        if(CheckIfBuildOptionIsValue("accessible", project, "True")):
                AddNodeWithText("accessible", "true", compilerNode)
                
        if(CheckIfBuildOptionIsValue("AllowSourcePathOverlap", project, "True")):
                AddNodeWithText("allow-source-path-overlap", "true", compilerNode)
                
        if(CheckIfBuildOptionIsValue("es", project, "True")):
                AddNodeWithText("es", "true", compilerNode)
                AddNodeWithText("as3", "false", compilerNode)
                
        if(CheckIfBuildOptionIsValue("strict", project, "False")):
                AddNodeWithText("strict", "false", compilerNode)
                
        if(CheckIfBuildOptionIsValue("showActionScriptWarnings", project, "False")):
                AddNodeWithText("show-actionscript-warnings", "false", compilerNode)
                
        if(CheckIfBuildOptionIsValue("showBindingWarnings", project, "False")):
                AddNodeWithText("show-binding-warnings", "false", compilerNode)
                
        if(CheckIfBuildOptionIsValue("showInvalidCSS", project, "False")):
                AddNodeWithText("show-invalid-css-property-warnings", "false", compilerNode)
                
        if(CheckIfBuildOptionIsValue("showDeprecationWarnings", project, "False")):
                AddNodeWithText("show-deprecation-warnings", "false", compilerNode)
                
        if(CheckIfBuildOptionIsValue("showUnusedTypeSelectorWarnings", project, "False")):
                AddNodeWithText("show-unused-type-selector-warnings", "false", compilerNode)
                
        if(CheckIfBuildOptionIsValue("useResourceBundleMetadata", project, "False")):
                AddNodeWithText("use-resource-bundle-metadata", "false", compilerNode)

        if(project["Debug"] == "False" and CheckIfBuildOptionIsValue("optimize", project, "True")):
                AddNodeWithText("optimize", "true", compilerNode)

        if(project["Debug"] == "False" and project["flex4"] == "True"):
                AddNodeWithText("omit-trace-statements", "true" if CheckIfBuildOptionIsValue("omitTraces", project, "True") else "false", compilerNode)

        if(project["Debug"] == "True"):
                AddNodeWithText("verbose-stacktraces", "true", compilerNode)
        else:
                AddNodeWithText("verbose-stacktraces", "true" if CheckIfBuildOptionIsValue("verboseStackTraces", project, "True") else "false", compilerNode)
                

def writeProjectToFlexConfigXml(project, filename):
        print("writeProjectToFlexConfigXml: %s" % filename)

        # create root element
        root = Element("flex-config")
        
        # targetPlayer
        targetPlayer = SubElement(root, "target-player")
        targetPlayer.text = "%s.%s" % (project["output"]["version"], project["output"]["minorVersion"])

        # Base Options
        if project["ASC2"] == "False":
                if CheckIfBuildOptionIsValue("benchmark", project, "False"):
                        AddNodeWithText("benchmark", "false", root)
                else:
                        AddNodeWithText("benchmark", "true", root)

        if CheckIfBuildOptionIsValue("staticLinkRSL", project, "True"):
                AddNodeWithText("static-link-runtime-shared-libraries", "true", root)
        else:
                AddNodeWithText("static-link-runtime-shared-libraries", "false", root)

        compilerNode = SubElement(root, "compiler")
        AddDefine("CONFIG::debug", "true" if project["Debug"] == "True" else "false", compilerNode)
        AddDefine("CONFIG::release", "false" if project["Debug"] == "True" else "true", compilerNode)
        AddDefine("CONFIG::timeStamp", strftime("'%d/%m/%Y'", time.localtime()), compilerNode)
        AddDefine("CONFIG::air", "true" if project["Mobile"] == "True" or project["Desktop"] == "True" else "false", compilerNode)
        AddDefine("CONFIG::mobile", "true" if project["Mobile"] == "True" else "false", compilerNode)
        AddDefine("CONFIG::desktop", "true" if project["Desktop"] == "True" else "false", compilerNode)

        if "compilerConstants" in project["build"]:
                if(len(project["build"]["compilerConstants"]) > 0):
                        for constant in project["build"]["compilerConstants"].split('\n'):
                                key, value = constant.split(",")
                                AddDefine(key, value, compilerNode)

        #CompilerOptions
        AddCompilerOptions(compilerNode, project)

        #ClassPaths
        sourcePathNode = AddNodeWithAttribute("source-path", "append", "true", compilerNode)

        for path in project["classpaths"]:
                AddNodeWithText("path-element", "..\\" + path, sourcePathNode)

        #Libraries
        if len(project["libraryPaths"]) > 0:
                # The example code uses a different tag include-libraries
                attributeNode = AddNodeWithAttribute("library-path", "append", "true", compilerNode)

                for path in project["libraryPaths"]:
                        AddNodeWithText("path-element", "..\\" + path, attributeNode)    

        #File Specs
        fileSpecs = SubElement(root, "file-specs")
        AddNodeWithText("path-element", "..\\" + project["compileTargets"][0], fileSpecs)

        # Add Defaults:
        AddNodeWithText("default-background-color", project["output"]["background"], root)
        AddNodeWithText("default-frame-rate", project["output"]["fps"], root)
        defaultSize = SubElement(root, "default-size")
        AddNodeWithText("width", project["output"]["width"], defaultSize)
        AddNodeWithText("height", project["output"]["height"], defaultSize)
        
        # write xml output to file
        indent(root)
        ElementTree(root).write(filename)


def indent(elem, level=0):
    i = "\n" + level*"  "
    if len(elem):
        if not elem.text or not elem.text.strip():
            elem.text = i + "  "
        if not elem.tail or not elem.tail.strip():
            elem.tail = i
        for elem in elem:
            indent(elem, level+1)
        if not elem.tail or not elem.tail.strip():
            elem.tail = i
    else:
        if level and (not elem.tail or not elem.tail.strip()):
            elem.tail = i


def run():
        if (len(sys.argv) != 3):
                print("Usage: %s input.as3proj output.xml" % sys.argv[0])
                exit()
        
        inputFile = sys.argv[1]
        outputFile = sys.argv[2]
                
        #inputFile = "data/example-input-nba.as3proj"
        #inputFile = "data/example-input-cartel.as3proj"
        #outputFile = "./output.xml"

        projectData = readAS3ProjToProject(inputFile)
        writeProjectToFlexConfigXml(projectData, outputFile)

        print("done")


run()
