FROM debian:latest
ENV container docker
USER root
ARG ssh_pub_key
ARG user

RUN apt update
RUN apt install -y systemd
RUN apt install -y vim
RUN apt install -y openssh-server tar; systemctl enable ssh

RUN yes 'y' | ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N ""
RUN yes 'y' | ssh-keygen -t rsa -f /etc/ssh/ssh_host_ecdsa_key -N ""

RUN mkdir /root/.ssh && touch /etc/ssh/ssh_config
RUN chown -R root:root /root/.ssh;chmod -R 700 /root/.ssh
RUN echo "StrictHostKeyChecking=no" >> /etc/ssh/ssh_config
RUN mkdir /var/run/sshd

ADD ./common/add_user.sh /add_user.sh

RUN chmod 755 /add_user.sh
RUN ./add_user.sh $user
RUN echo "$ssh_pub_key" > /home/$user/.ssh/authorized_keys
RUN cp /home/$user/.ssh/authorized_keys /root/.ssh/
RUN chown -R $user:root /etc/ssh

ENTRYPOINT ["/usr/sbin/sshd", "-D"]

