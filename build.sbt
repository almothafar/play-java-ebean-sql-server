name := "play-java-ebean-example"

version := "1.0.0-SNAPSHOT"

scalaVersion := "2.13.1"

lazy val root = (project in file(".")).enablePlugins(PlayJava, PlayEbean)

// You can easily navigate from error pages to IntelliJ directly into the source code,
// by using IntelliJ’s “remote file” REST API with the built in IntelliJ web server on port 63342.
javaOptions += "-Dplay.editor=http://localhost:63342/api/file/?file=%s&line=%s"

val javaVersion = settingKey[String]("The version of Java used for building.")

javaVersion := System.getProperty("java.version")

// To provide an implementation of JAXB-API, which is required by Ebean.
val java9AndSupLibraryDependencies: Seq[sbt.ModuleID] =
  if (!javaVersion.toString.startsWith("1.8")) {
    Seq(
      "com.sun.activation" % "javax.activation" % "1.2.0",
      "com.sun.xml.bind" % "jaxb-core" % "2.3.0.1",
      "com.sun.xml.bind" % "jaxb-impl" % "2.3.1",
      "javax.jws" % "javax.jws-api" % "1.1",
      "javax.xml.bind" % "jaxb-api" % "2.3.1",
      "javax.xml.ws" % "jaxws-api" % "2.3.1"
    )
  } else {
    Seq.empty
  }


libraryDependencies ++= Seq(
  guice,
  javaJdbc,
  caffeine,
  filters,
  evolutions,
  "com.microsoft.sqlserver" % "mssql-jdbc" % "7.4.1.jre11"
) ++ java9AndSupLibraryDependencies


libraryDependencies += "org.awaitility" % "awaitility" % "2.0.0" % Test
libraryDependencies += "org.assertj" % "assertj-core" % "3.12.2" % Test
libraryDependencies += "org.mockito" % "mockito-core" % "2.25.1" % Test

// Make verbose tests
testOptions in Test := Seq(Tests.Argument(TestFrameworks.JUnit, "-a", "-v"))

javacOptions ++= Seq("-Xlint:unchecked", "-Xlint:deprecation", "-Werror")
