#!/bin/bash
#
# mailFile.func.sh: Functions for mailing text file
#
#  . /etc/cron.includes/mailFile.func.sh
#
#  MailFileCreate "/path/to/file.txt (optional if defined, otherwise required)"
#  MailFileSMTP "Sender <sender@domain.com> (required, can be empty)" \
#		"My File (required, can be empty)" \
#		"recipient@domain.com (required, can be empty)" \
#		"/path/to/file.txt (optional)"
#
#
#
mailFrom="Me <sender@domain.com>"
mailSubject="My File"
mailTo="recipient@domain.com"
mailFile="/path/to/file.txt"

# Sendmail utility
mailExe="/usr/bin/mail"

#################################
##                             ##
## DO NOT EDIT BELOW THIS LINE ##
##                             ##
#################################
createMailFile="NO"

# Function: MailFileCreate()
# Create pending mail file
function MailFileCreate()
{
	if [ "$1" ];
	then
		mailFile="$1"
	fi

	if [ ${createMailFile} == "YES" ];
	then
		if [ -e ${mailFile} ];
		then
			rm ${mailFile}
		fi
	fi

	touch ${mailFile}
	return
}

# Function: mailFileSTMTP
# Mail pending file
function MailFileSMTP()
{
	if [ "$1" ] && [ ! -z "$1" ];
	then
		mailFrom="$1"
	fi

	if [ "$2" ] && [ ! -z "$2" ];
	then
		mailSubject="$2"
	fi

	if [ "$3" ] && [ ! -z "$3" ];
	then
		mailTo="$3"
	fi

	if [ "$4" ] && [ ! -z "$4" ];
	then
		mailFile="$4"
	fi

	if [ -e "${mailFile}" ];
	then
		if [ -s "${mailFile}" ];
		then
			if [ -x "${mailExe}" ];
			then
				${mailExe} -a FROM:"${mailFrom}" -s "${mailSubject}" ${mailTo} < ${mailFile}
			else
				echo "nothing"
			fi
		fi
		rm ${mailFile}
	fi

	# Unset variable for creating new log file
	createMailFile="NO"
	return
}

# Function: echoMailFile
# Add new line to file to be mailed
function echoMailFile()
{
	echo "" >> ${mailFile}
	return
}

##
## EOF
##
