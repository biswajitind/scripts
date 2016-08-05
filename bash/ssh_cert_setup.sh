#!/bin/bash

#This is a shell script. a bash shell script, to be more specific. as you can see
#at the first line. The first line of a shell script must start with a #!
#followed by the path to the program which will execute this script.
#any line starting with a # is a comment line, which is not executed by the shell.

#$1  $2 etc till $9 are special variables in shell script.
#$1 will have the value passed on the script as the first arguement.
#$2 will have the second. This means if we execute this script as 
#       ssh_cert_setup.sh -add myhost.xyz.com
# $1 will have the value -add , and $2 will have myhost.xyz.com
# In the following lines we are capturing these values into variables that we are defining ourself.
#

ARG1=$1
ARG2=$2
# Store the current user and the hostname in variables, to be used later.
CHOST=`hostname`;
CUSER=`whoami`;
#check if the public key is available in its pre-defined location. ~/ means the current users home directory.
if [ -f ~/.ssh/id_rsa.pub ]
then
 echo "Found ~/.ssh/id_rsa.pub"
else
 #If the public key is not available, execute ssh-keygen to create a pair of keys (a private key and a public key )
 echo "Error: Could not find ~/.ssh/id_rsa.pub"
 CMD="ssh-keygen -t rsa -C \"${CUSER}@scmone.com\""
 echo "Generating a key pair."
 echo "**WHEN PROMPTED for KEY PHRASE, dont enter any textm just enter**"
 $CMD
fi
# if the first argument to the program is not -add the print a error message and come out without doing anything.
if [ "$ARG1" == "-add" ]
then
 # If a second argument is not specified. then print a error message and come out.
 if [ "$ARG2" == "" ]
 then
 echo "ERROR: Please specify a hostname with \"add\" sub-command"
 echo "Usage: br add "
 exit 1
 else
 echo "setting up passwordless ssh to $ARG2"
 CMD1="scp ${HOME}/.ssh/id_rsa.pub ${CUSER}@${ARG2}:~/id_rsa.pub.${CUSER}"
 CMD2="ssh -q $ARG2 mkdir -p ~/.ssh; cat ~/id_rsa.pub.${CUSER} >> ~/.ssh/authorized_keys; chmod 700 ~/.ssh; chmod 600 ~/.ssh/authorized_keys"
# CMD2="ssh -q $ARG2 hostname;pwd; echo $PATH"
 if [ "$DMPD_DEBUG" == "1" ]
 then
   echo "$CMD1 ; $CMD2"
 else
 $CMD1
 $CMD2
 fi
 fi
fi
