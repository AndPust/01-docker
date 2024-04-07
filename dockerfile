FROM ubuntu:22.04

RUN apt-get update

# installing "add-apt-repository" to easily install old pythons
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:deadsnakes/ppa

# adding "noninteractive" to automatically choose the defaults during installation
RUN DEBIAN_FRONTEND="noninteractive" apt-get install -y python3.8

# setting python3.8 as the default one
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.8 1
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.8 1

# installing Java 8 JDK and Kotlin
RUN apt-get install -y openjdk-8-jdk
RUN apt-get install -y kotlin

# installing Gradle
RUN apt-get install wget
RUN mkdir ./gradle
RUN wget -c https://services.gradle.org/distributions/gradle-8.7-bin.zip -P ./gradle/
RUN unzip -d ./gradle/gradle/ ./gradle/gradle-8.7-bin.zip
ENV PATH=$PATH:/gradle/gradle/gradle-8.7/bin

# Copying gradle project to the container
RUN mkdir gradle_project
WORKDIR /gradle_project
COPY build.gradle .
COPY src ./src
RUN gradle build

CMD gradle run
