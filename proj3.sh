#!/bin/bash

# main menu function
mainmenu(){
	# clear screen
	clear
	# print date
	now=$(date)
	echo $now
	printdash
	# print menu options
	echo "Main Menu"
	printdash
	echo "1.  Operating System info"
	echo "2.  Hostname and DNS info"
	echo "3.  Network info"
	echo "4.  Who is online"
	echo "5.  Last logged in users"
	echo "6.  My IP address"
	echo "7.  My disk usage"
	echo "8.  My home-file tree"
	echo "9.  Process operations"
	echo "10. Exit"
	echo "Enter your choice [ 1 - 10 ]"
	# get selection and call appropriate function
	read menuselect
	case $menuselect in
		1)
			osinfo
			;;
		2)
			dnsinfo
			;;
		3)
			netinfo
			;;
		4)
			whois
			;;
		5)
			lastuser
			;;
		6)
			myip
			;;
		7)
			mydisk
			;;
		8)
			mytree
			;;
		9)
			fileops
			;;
		10)
			exit 0
			;;
		*)
			# invalid inputs
			echo "Unknown input! Please try again"
			read -p "Press [ENTER] key to continue..."
			mainmenu
			;;
	esac
}

# helper function for printing dashes on headers
printdash(){
	printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
}

# helper function for returning to main menu
returntomain(){
	read -p "Press [ENTER] key to continue..."
	mainmenu
}

# helper function to return to file ops menu
returntofileops(){
	echo "Enter \":q\" to return to the submenu..."
	read exitcommand
	if [ $exitcommand = ":q" ]
	then
		fileops
	else
		returntofileops
	fi
}

osinfo(){
	clear
	printdash
	echo "System Information"
	printdash
	echo "Operating System: Linux"
	/usr/bin/lsb_release -a
	returntomain
}

dnsinfo(){
	clear
	printdash
	echo "Hostname and DNS Information"
	printdash
	hostname=$(hostname)
	dnsname=$(hostname -d)
	fqdn=$(hostname -f)
	ipaddr=$(hostname -I)
	nameserver=$(grep -o "nameserver.*" /etc/resolv.conf | cut -c 12-)
	echo "Hostname : $hostname"
	echo "DNS Domain : $dnsname"
	echo "Fully Qualified Domain Name : $fqdn"
	echo "Network Address (IP) : $ipaddr"
	echo "DNS name servers (DNS IP) : $nameserver"
	returntomain
}

netinfo(){
	clear 
	printdash
	echo "Network Information"
	printdash
	numinterfaces=$(ls -A /sys/class/net | wc -l)
	echo "Total network interfaces found : $numinterfaces"
	echo "*** IP Addresses Information ***"
	ip addr
	echo "************************"
	echo "*** Network Routing ****"
	echo "************************"
	netstat -rn
	echo "*************************************"
	echo "*** Interface Traffic Information ***"
	echo "*************************************"
	netstat -i
	returntomain
}

whois(){
	clear
	printdash
	echo "Who Is Online"
	printdash
	who -H
	returntomain
}

lastuser(){
	clear
	printdash
	echo "List of last logged in users"
	printdash
	last | tail -n +2
	returntomain
}

myip(){
	clear
	printdash
	echo "Public IP Information"
	printdash
	# get public IP
	dig +short myip.opendns.com @resolver1.opendns.com
	returntomain
}

mydisk(){
	clear
	printdash
	echo "Disk Usage Info"
	printdash
	df --output=pcent,source
	returntomain
}

mytree(){
	clear
	printdash
	echo "Home File-tree"
	printdash
	# supress errors for unreadable directories
	./proj1.sh /home/ ~/filetree.html 2>/dev/null
	returntomain
}
fileops(){
	clear
	printdash
	echo "Process Operations"
	printdash
	# print menu options
	echo "(Please Enter The Number of Your Selection Below)"
	printf "\n"
	echo "1. Show All Processes"
	echo "2. Kill a Process"
	echo "3. Bring Up Top"
	echo "4. Return to Main Menu"
	# get selection
	read menuselect
        case $menuselect in
                1)
                        showprocess
                        ;;
                2)
                        killprocess
                        ;;
                3)
                        bringtop
                        ;;
                4)
                        mainmenu
                        ;;
		*)
                        echo "Unknown input! Please try again"
                        read -p "Press [ENTER] key to continue..."
			fileops
                        ;;
        esac


}

showprocess(){
	clear
	printdash
	echo "Show All Processes"
	printdash
	ps -o uid,pid,ppid,stime,tty,time,cmd
	returntofileops
}

killprocess(){
	echo "Please enter the PID of the process you would like to kill:"
	echo "Enter \":q\" to return to the submenu..."
	# get PID
	read processnum
	# exit if input is :q
        if [ $processnum = ":q" ]
        then
                fileops
        else
		# kill process
                kill $processnum
		killprocess
     	fi
}
bringtop(){
	top
	fileops
}
mainmenu

