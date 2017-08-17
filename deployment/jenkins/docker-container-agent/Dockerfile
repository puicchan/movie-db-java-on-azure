FROM jenkinsci/jnlp-slave

MAINTAINER vscjenkins@microsoft.com

USER root
# Install apt-utils
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        apt-utils \
        curl

RUN apt-get -y update && apt-get -y upgrade

RUN apt-get -y install git
RUN mkdir -p /usr/share/maven /usr/share/maven/ref \
    && curl -fsSL -o /tmp/apache-maven.tar.gz http://www-us.apache.org/dist/maven/maven-3/3.5.0/binaries/apache-maven-3.5.0-bin.tar.gz \
    && tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1 \
    && rm -f /tmp/apache-maven.tar.gz \
    && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

# Install docker
RUN apt-get install -y \
    apt-transport-https \
    ca-certificates \
    software-properties-common
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"
RUN apt-get update && \
    apt-get install -y docker-ce
ADD initagent.sh /usr/local/bin/initagent.sh
RUN chmod 755 /usr/local/bin/initagent.sh
ENTRYPOINT ["initagent.sh"]
# RUN usermod -aG docker jenkins

# USER jenkins
