# ssh-helper - a small console frontend for ~/.ssh/config
This application consists of a simple shell skript, which polls your ~/.ssh/config (or wherever your config may lie, path can be changed in one of the first lines), lists all hosts and then offers a prompt to select the desired host by typing a number. It may not be the first and definitely not the last application created for this usecase, but it's slim, and does its job.

### Prerequisites
- openssh
- a openssh config (in a path known to openssh and readable by your user, ssh myhostalias must work as my skript relies on it)
- complete config - each host must feature an alias, hostname/IP, login-name and port. If one is incomplete, the script will not work (but output an error)
- bash (I have not tried it in other shells, so it may or may not work)

Example of a config file entry:
```bash
Host web
	HostName web.myhost.mytld
	User web
	Port 22
```

### Features
- Simple terminal-frontend to allow you to connect to all your SSH hosts without remembering and typing usernames, ports, IPs or even aliases all the time
- (Customizable) colors to increase readability of the output - default is my color theme
- (Somewhat helpful) error messages if there are issues with the config file path or content

Sample output:
```bash
[mp ~] ./ssh-helper.sh 
List of available hosts:
[1] weechat    chat@weechat.myhost.mytld -p 2223
[2] web        web@web.myhost.mytld -p 22
[3] router     root@192.168.10.1 -p 22

Input: 3
Connecting to "router"
```
