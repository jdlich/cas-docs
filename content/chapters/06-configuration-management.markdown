# Configuration Management #

Configuration management is how you're going to manage your CAS implementation for real.

## Maven War Overlay ##

_TODO: Document Maven Overlay, inspired by and merging in the content of [best practices](https://wiki.jasig.org/display/CASUM/Best+Practice+-+Setting+Up+CAS+Locally+using+the+Maven2+WAR+Overlay+Method)._

### Assumptions ###

This documentation on how to use Maven Overlay assumes that you already understand how to install CAS and what it requires. It assumes you've already got Java and a servlet container and have done something sensible about SSL certificates and so forth. That is, the scope of this chapter is exclusively what's special about the Maven Overlay approach.

While using Maven Overlay is highly recommended, don't start here! CAS ships a perfectly reasonable ready-to-deploy .war file for trying out CAS on your local computer running it on localhost. Start there before building your own custom CAS .war using this Maven overlay approach.

### Installing Maven 2 ###

While you also need Maven to build CAS itself from source, a Maven Overlay approach to configuration heavily depends on Maven, so here's some tips for Maven2 installation. Maven2 is not a Jasig product and has its own website.

The latest version of Maven as of this writing is Maven 3.0.3, but CAS is still most adopted with and most tested with Maven 2, so these instructions assume and are tested with Maven 2.

Maven 1 just won't work with the Maven overlay approach (and is pretty old technology at this point). You must use Maven 2 or later.

#### Obtaining and Installing ####

Your environment may already have Maven installed. For instance, Macintosh OS X typically includes a Maven distribution by default. You might want to use or upgrade that rather than install a new version of Maven. Then again, you might want the control of downloading and installing a specific version.

In any case, one way to get Maven is to download it from the Maven website. The latest version of Maven 2 as of this writing is Maven 2.2.1. You could install it to somewhere like _/opt/apache-maven-2.2.1_ . Life will be easier if you choose a path that does not include spaces in the names of its directories. Regardless of where you install Maven, this documentation refers to this path as $MAVEN_HOME.

#### Setting Maven-related environment variables and adding the executable to the Path... ####

Once you've downloaded and expanded the Maven 2 binary, or decided to use a version of Maven 2 that shipped in your operating system, you'll need to expose a M2_HOME environment variable. You may need to set other Maven options as an environment variable, and you may be happier if you put Maven on your Path so you can execute it easily from the command line.

#### ...on Unix-like Operating Systems #### 

These instructions work in general on Mac OS X and on Linux variants. Best practices and conventions for permanently setting environment variables will vary depending upon the detauls of your environment.

In a command terminal, add the M2_HOME environment variable, e.g. 

    export M2_HOME=$MAVEN_HOME 

. Recall that $MAVEN_HOME is the placeholder in this documentation for the path to wherever your Maven 2 installation lives.

Add the M2 environment variable, e.g. 

    export M2=$M2_HOME/bin 
.

Optionally, add the MAVEN\_OPTS environment variable to specify JVM properties, e.g. 

  export MAVEN_OPTS="-Xms256m -Xmx512m"

. This environment variable can supply extra options to Maven and to the Java Virtual Machine in which Maven will run.

Add the M2 environment variable to your path, e.g. 
  export PATH=$M2:PATH.

Ensure that the JAVA\_HOME environment variable is set to the location of your JDK, e.g. 
    export JAVA_HOME=/usr/java/jdk1.5.0_02 
and that $JAVA_HOME/bin is in your PATH environment variable.

Run 
    mvn --version 

to verify that Maven 2 is correctly installed.

Example result of running _mvn --version_ :

    you@hostname:~$ mvn --version Apache Maven 2.2.1 (rdebian-4) Java version: 1.6.0_26 Java home: \
    /usr/lib/jvm/java-6-sun-1.6.0.26/jre Default locale: en_US, platform encoding: \
    UTF-8 OS name: "linux" version: "2.6.38-11-generic" arch: "amd64" Family: "unix" 
    you@hostname:~$


#### ...on Windows ####

Add the M2\_HOME environment variable by opening the system properties (WinKey + Pause), selecting the "Advanced" tab, clicking the "Environment Variables" button, then adding the M2\_HOME variable to the set of user variables with value $MAVEN_HOME (recall that $MAVEN_HOME is the placeholder in this documentation for the path to your Maven installation, something like /opt/apache-maven-2.2.1 . Be sure to omit any quotation marks around the path even if it includes spaces. The value of M2\_HOME should not end with a \ character -- if you're using Maven 2.0.9 or earlier, it must not end with a slash character.

In the same dialog, add an environment variable M2 with value 
    %M2_HOME%\\bin 
.

Optionally, in the same dialog, add the MAVEN\_OPTS environment variable in the user variables to specify JVM properties for use with Maven. For example, the value "-Xms256m -Xmx512m" instructs Maven to use at least 256 megabytes and at most 512 megabytes of memory. More ambitious usages of Maven can require more than the default allocation of memory. In general, the MAVEN\_OPTS environment variable supplies extra JVM configuration to Maven.

In the same dialog, create or update a Path environment variable in the user variables and prepend the value "%M2%" to make the Maven executable available ubiquitously on the command line.

In the same dialog, ensure that the JAVA_HOME exists in your user variables or in the system variables and is set to the location of your JDK, e.g. "C:\\Program Files\\Java\\jdk1.5.0\\_02" and that "%JAVA_HOME%\\bin" is in the Path environment variable.

Open a new command prompt (Winkey + R then type "cmd" and press Enter) and run "mvn --version" to verify that Maven is correctly installed and runnable from the command line.




### Setting up your local Maven-Overlay-using CAS project ###

Working with a Maven2-based project may be different from when you worked with an Ant-based project. For many people, Ant-based projects included things like manually managing dependencies, building source for external projects that you were integrating with, keeping binary JAR files in your version control system, and manually crafting Ant build files. Maven2 is a different way of thinking. The libraries or projects you're working with maintain the list of required dependencies, Maven2 attempts to resolve them and any conflicts, downloads them and keeps them in a local cache. It also uses standard "goals" (which were often called tasks in Ant). Recent versions of Ant have included some of these features with add-ons such as Ivy 2.0. At this point, there is no expectation that you understand completely how Maven2 works. We'll explain the important concepts as we go along.

In particular for CAS, we'll be working with what's called a "WAR Overlay." Essentially, the CAS open source project has already built and made available a CAS webapplication as part of the standard CAS distribution. What you're interested in doing is ADDING to and modifying the configuration of this standard distribution, possibly by adding new files or configuration, new dependencies, or replacing a few of the standard files. This WAR Overlay process supports all of this modification. We always recommend this process because if keeps you out of the business of downloading the CAS source, building it, making your customizations, rebuilding it, etc. and maintaining a copy of Jasig CAS server source code locally. With the WAR overlay, you're only keeping the files you've locally changed, so your local CAS project is more expressive of what is unique, special, and different in your local configuration and customization of CAS.

#### Your local CAS project directory #### 

Your local CAS project's source code will consist of a directory, a folder with files in it representing the description of your local CAS implementation.

The first step therefore is to create this directory, your local workspace. This tutorial doesn't require an IDE, and you may not need an IDE to cope with the relatively few files involved.

You can put this directory anywhere you like. If you need somewhere, /opt/work is a good spot.

In any case, this documentation will refer to this workspace directry as $WORKSPACE , and we won't refer to it much, because the very next step is to create a directory within it where all the real work will happen.

Within $WORKSPACE, add a directory for your local organization's CAS project, that is, the directory for the project of your local CAS configurations and customizations. You might call this local-cas, yielding a path $WORKSPACE/local-cas . This documentation will refer to this directory as your $PROJECT\_HOME .

Into your $PROJECT\_HOME directory will go two things: a special file named pom.xml that describes your local CAS implementation as a Maven Overlay war project, and all of the changed and new files that make your local implementation differ from the CAS .war as delivered by the CAS open source project.

#### Your pom.xml ####

You CAS implementation's pom.xml describes your local institution's CAS implementation as a Maven project. This pom.xml. should go directly in your $PROJECT\_HOME directory, as in $PROJECT\_HOME/pom.xml

_The rest of the documentation..._

_TODO! Here goes the meat of all the really useful and Maven-overlay-specific documentation!_
