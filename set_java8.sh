#!/bin/bash

# Set JAVA_HOME to Java 8
export JAVA_HOME="/Library/Java/JavaVirtualMachines/temurin-8.jdk/Contents/Home"
export PATH="$JAVA_HOME/bin:$PATH"

echo "Java 8 is now active:"
java -version
