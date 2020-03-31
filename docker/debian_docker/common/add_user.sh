#!/bin/bash

__create_user() {
# Create a user to SSH into as.
useradd -ms /bin/bash -G root -d /home/$1 $1
SSH_USERPASS=''

mkdir -p /home/$1/.ssh
chmod 700 /home/$1/.ssh
touch /home/$1/.ssh/authorized_keys
chown -R $1:root /home/$1/.ssh;chmod -R 700 /home/$1/.ssh
}

# Call all functions
__create_user $1
