FROM ubuntu:16.04
RUN apt-get update && apt-get install -y openssh-server
RUN mkdir /var/run/sshd && mkdir /var/sftp && mkdir /var/sftp/uploads && mkdir /var/sshKeys
RUN chmod 777 /var/sftp/uploads
COPY /sshStuff/. /etc/ssh/
COPY /sshKeys/. /var/sshKeys/
COPY /sshKeys/ssh_host_rsa_key /var/sshKeys/ssh_host_rsa_key_readable
RUN chmod 600 /var/sshKeys/ssh_host_rsa_key
RUN useradd -ms /bin/bash sshuser
RUN echo 'sshuser:P@$$w0rd' | chpasswd
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
RUN usermod -d /var/sftp/uploads sshuser

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]