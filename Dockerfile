FROM ubuntu:14.04

RUN apt-get update -y
RUN apt-get install openjdk-7-jre -y
RUN apt-get install tomcat7

CMD java -v
