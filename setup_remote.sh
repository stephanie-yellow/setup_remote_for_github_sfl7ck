#!/bin/bash
# This script sets up an AWS remote instance for github with your creds
# Fill out the all the variables then run "make remote"
# The script will
#    copy your github key to the remote .ssh folder
#    create an ssh config file with your github key name and copy it to the remote .ssh folder
#    use your github user name and email to set those up as defaults on the remote
#


PUBLIC_IP=100.26.20.129
if [ -z "$PUBLIC_IP" ];then echo "PUBLIC_IP is empty!"; exit 1; fi

# This one needs the full PATH
AWS_PEM_KEY_PATH=~/.ssh/dpy8wq_230918T1755.pem
if [ -z "$AWS_PEM_KEY_PATH" ];then echo "AWS_PEM_KEY_PATH is empty!"; exit 1; fi

# This one needs the full PATH
GH_KEY_PATH=~/.ssh/EfrainOlivaresUVA
if [ -z "$GH_KEY_PATH" ];then echo "GH_KEY_PATH is empty!"; exit 1; fi

# This is just the NAME of your github ssh key
GH_KEY_NAME=EfrainOlivaresUVA
if [ -z "$GH_KEY_NAME" ];then echo "GH_KEY_NAME is empty!"; exit 1; fi

USER=EfrainOluvaresUVA
if [ -z "$USER" ];then echo "USER is empty!"; exit 1; fi

EMAIL=efrainolivaresuva@gmail.com
if [ -z "$EMAIL" ];then echo "EMAIL is empty!"; exit 1; fi


# copy github key to remote
scp -i ${AWS_PEM_KEY_PATH} ${GH_KEY_PATH} ubuntu@${PUBLIC_IP}:/home/ubuntu/.ssh/

# create an ssh condfig on the fly, insert your key name and copy it to remote, then clean up
cat <<EOT > config
Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/${GH_KEY_NAME}
    IdentitiesOnly Yes
EOT
scp -i ${AWS_PEM_KEY_PATH} config ubuntu@${PUBLIC_IP}:/home/ubuntu/.ssh/
rm config

# execute remotely to set up your github user and email as defaults, then list them for feedback
ssh -i ${AWS_PEM_KEY_PATH} ubuntu@${PUBLIC_IP} git config --global user.name ${USER}
ssh -i ${AWS_PEM_KEY_PATH} ubuntu@${PUBLIC_IP} git config --global user.email ${EMAIL}
ssh -i ${AWS_PEM_KEY_PATH} ubuntu@${PUBLIC_IP} git config --global --list
