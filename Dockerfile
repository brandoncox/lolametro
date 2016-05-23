# sshd
#
# VERSION               0.0.2

FROM karsuncsb/jdk:7
MAINTAINER Kevin Sarabi <kevin.sarabi@karsun-llc.com>

#************jboss setup
ENV eap_version 6.2
ADD jboss-eap-${eap_version}.zip /tmp/jboss-eap-${eap_version}.zip
ADD jboss${eap_version}_ctl /etc/init.d/jboss_ctl
RUN apt-get install unzip
RUN mkdir -p /opt/sw
RUN useradd -md /opt/sw/jboss jboss
RUN mkdir -p /opt/sw/jboss/jboss && cd /opt/sw/jboss/jboss && unzip /tmp/jboss-eap-${eap_version}.zip
ADD jboss${eap_version}_init.sh /opt/sw/jboss/jboss/jboss-eap-${eap_version}/bin/jboss_init.sh
RUN chmod +x /etc/init.d/jboss_ctl /opt/sw/jboss/jboss/jboss-eap-${eap_version}/bin/*
RUN update-rc.d jboss_ctl defaults
RUN cp -r /root/.ssh/ /opt/sw/jboss
RUN chown -R jboss /opt/sw/jboss
EXPOSE 22 8080 8443
ADD startup.sh /root/
RUN chmod u+x /root/startup.sh
 # Clean up APT when done.  
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
CMD ["/root/startup.sh","-D"]
