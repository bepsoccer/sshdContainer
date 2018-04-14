FROM alpine:latest
RUN apk add --update openssh && rm -rf /var/cache/apk/*

RUN mkdir /var/run/sshd && mkdir /var/sftp && mkdir /var/sftp/uploads && mkdir /var/sshKeys
RUN chmod 777 /var/sftp/uploads
COPY /sshStuff/. /etc/ssh/
COPY /sshKeys/. /var/sshKeys/
COPY /sshKeys/ssh_host_rsa_key /var/sshKeys/ssh_host_rsa_key_readable
RUN chmod 600 /var/sshKeys/ssh_host_rsa_key
RUN adduser -D -h /var/sftp/uploads sshuser
RUN echo 'sshuser:P@$$w0rd' | chpasswd

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D", "-e"]