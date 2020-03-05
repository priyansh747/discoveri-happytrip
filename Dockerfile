FROM ubuntu:14.04

RUN apt-get update
RUN apt-get install openjdk-7-jre

CMD java -v
