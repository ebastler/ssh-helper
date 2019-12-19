#!/bin/bash

###########
# Bash script to poll the ssh config file for hosts and offer a minimalistic prompt in the shell 
# to choose the connection target.
# It then connects using the aliases defined in ssh config.
# Path to the config file, as well as colors of various parts of the shell output can be defined below.

# Config: path to the ssh config file
configPath=~/.ssh/config

# Config: color codes for various parts of the output. 
colAlias='\033[38;5;45m'       # Color of the server alias printed first
colConnection='\033[0m'        # Color of "mynickname" and "myhost.tld"
colPorts='\033[0m'             # Color of the ports
colVar='\033[0;37m'            # Color of brackets around the number, "@" and "-p"
colNumbers='\033[38;5;45m'     # Color of the host numbering


# Resets the output color to the terminal default
colDefault='\033[0m'

# Check if the config file exists and is readable, otherwise exit with an error message
if [ ! -f $configPath ]
then
	printf "Invalid config file path %s \n" $configPath
	exit 1
fi

# Read all relevant fields (important: Ports have to be set for every connection, even if it uses the default 22)
# Store the data in 1D Arrays
serverAlias=(`cat $configPath | awk -F"[ ]+" '/Host /{printf $2 " "}'`)
hostNames=(`cat $configPath | awk -F"[ ]+" '/HostName /{printf $2 " "}'`)
loginNames=(`cat $configPath | awk -F"[ ]+" '/User /{printf $2 " "}'`)
ports=(`cat $configPath | awk -F"[ ]+" '/Port /{printf $2 " "}'`)

# Check if all hosts were complete (all arrays have the same length), otherwise exit with an error message
if (( ${#serverAlias[@]} != ${#hostNames[@]} || ${#loginNames[@]} != ${#ports[@]} || ${#hostNames[@]} != ${#loginNames[@]} ))
then
	printf "Incomplete config file, one or more hosts are lacking parameters\n"
	exit 1
fi

# Print the host list to the terminal
printf 'List of available hosts:\n'
for (( i=0; i<${#serverAlias[@]}; i++ ))
do
	printf '%b[%b%s%b]%b %-10s %b%s%b@%b%s %b-p%b %s%b\n' $colVar $colNumbers $(($i+1)) $colVar $colAlias ${serverAlias[i]} $colConnection ${loginNames[i]} $colVar $colConnection ${hostNames[i]} $colVar $colPorts ${ports[i]} $colDefault
done
printf '\n'

# Wait for a user input number
read -p "Input: " serverChoice

# Check if the number is between 1 and the amount of hosts in the config file, otherwise ask again
while (( $serverChoice < 1 || $serverChoice > ${#serverAlias[@]} ))
do
	printf "Please enter a valid number between 1 and %s\n" ${#serverAlias[@]}
	read -p "Input: " serverChoice
done

printf 'Connecting to "%s"\n' ${serverAlias[$serverChoice-1]}

# Conect to the selected host, using the ssh config alias
ssh ${serverAlias[$serverChoice-1]}

exit 0