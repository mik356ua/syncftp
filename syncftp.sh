#!/bin/bash
#
# Script syncronizes remote FTP with local folder

# check arguments
if [ $# -lt 1 ]; then
    echo 'Not enough arguments. Type "--help" for help.'
    exit
elif [ $1 = "--help" ]; then
    cat <<EOL
Script syncronizes remote FTP with local folder. Requires lftp installed (apt-get install lftp). Usage:

    ./syncftp.sh -h host -u user -p password -s source -t target

Examples:

    ./syncftp.sh -h mysite.com -u myuser -p p$$wrd -s /home/myuser/mysite -t /httpdocs

EOL
    exit
fi

# default vars
HOST=
USER="`whoami`"
PASS=
TARGETFOLDER='/'
SOURCEFOLDER=

# handle arguments
for (( i = 1, j = 2; i < $#; i++, j++ )); do
    KEY=${!i}
    VAL=${!j}
    case $KEY in
        -h)
            HOST="$VAL"
            ;;
        -u)
            USER="$VAL"
            ;;
        -p)
            PASS="$VAL"
            ;;
        -s)
            SOURCEFOLDER="$VAL"
            ;;
        -t)
            TARGETFOLDER="$VAL"
            ;;
    esac
done

# check required vars
if [[ -z "$HOST" ]] || [[ -z "$USER" ]] || [[ -z "$SOURCEFOLDER" ]] || [[ -z "$TARGETFOLDER" ]]; then
    echo 'Not enough arguments. Type "--help" for help.'
    exit
fi

# run command
lftp -f "
open $HOST
user $USER $PASS
lcd $SOURCEFOLDER
mirror --reverse --delete --verbose $SOURCEFOLDER $TARGETFOLDER
bye
"