#!/bin/sh
# - openbsd specific code
# note hard coding for authpf user accounts (i.e. keys being automatically
# found and copied

if [ -x /usr/local/bin/spew.pl ]; then
        PWDGEN=/usr/local/bin/spew.pl
elif [ -x /usr/local/sbin/spew.pl ]; then
        PWDGEN=/usr/local/sbin/spew.pl
else
        echo "Password Generator spew.pl not installed or executable"
        exit 1
fi

AUTHORIZED_KEYSFILE=`grep AuthorizedKeysFile /etc/ssh/sshd_config | awk '{ print $2 }'`
KEYFILE_SUBDIR=`echo ${AUTHORIZED_KEYSFILE} | awk -F / '{ print $1 }'`

create_admins() {
        echo "--------------------------------------------------"
        echo "Enter 'space' separated username for ADMINISTRATORS"
        echo "Login Class: staff; Group: +wheel; Shell /usr/sbin/authpf"
        echo "--------------------------------------------------"
        echo "For example: aldo samt"

        read ADMINS
        if [ ! -z "$ADMINS" ]; then
                for USER in ${ADMINS}; 
                do 
                        KNOWNUSER=`grep "^${USER}:" /etc/passwd`
                        if [ -z $KNOWNUSER ]; then
                                DEFAULT_PASSWORD=`${PWDGEN} | /usr/bin/encrypt -b 6`;
                                /usr/sbin/groupadd "${USER}";
                                /usr/sbin/useradd -mv -b /home \
                                -c "${USER}" \
                                -L staff \
                                -g "${USER}" \
                                -G wheel \
                                -s /bin/ksh \
                                -p "${DEFAULT_PASSWORD}" \
                                "${USER}";
                        else
                                echo "Known Administrator: $KNOWNUSER"
                        fi
                done
                DEFAULT_PASSWORD=""
                verify_usercreation "${ADMINS}"
                copy_sshkeys "${ADMINS}"
        fi
}

create_users() {
        echo "--------------------------------------------------"
        echo "Enter 'space' separated username for REGULAR User Accounts"
        echo "Login Class: default; Shell: /bin/ksh"
        echo "--------------------------------------------------"
        echo "For example: __monitor"
        read NON_ADMINS
        if [ ! -z "$NON_ADMINS" ]; then
                for USER in ${NON_ADMINS}; 
                do 
                        KNOWNUSER=`grep "^${USER}:" /etc/passwd`
                        if [ -z "$KNOWNUSER" ]; then
                                DEFAULT_PASSWORD=`${PWDGEN} | /usr/bin/encrypt -b 6`;
                                /usr/sbin/groupadd "${USER}";
                                /usr/sbin/useradd -mv -b /home \
                                -c "${USER}" \
                                -L default \
                                -g "${USER}" \
                                -s /bin/ksh \
                                -p "${DEFAULT_PASSWORD}" \
                                "${USER}";
                                DEFAULT_PASSWORD=""
                        else
                                echo "Known User: $KNOWNUSER"
                        fi
                done
                verify_usercreation "${NON_ADMINS}"
                copy_sshkeys "${NON_ADMINS}"
        fi
}
create_users_authpf() {
        echo "--------------------------------------------------"
        echo "Enter 'space' separated username for AUTHPF User Accounts"
        echo "Login Class: authpf; Shell /usr/sbin/authpf"
        echo "--------------------------------------------------"
        echo "For example: aldo_authpf samt_authpf"
        echo "             use '_authpf' to designate the account type"
        read AUTHPF_USERS
        if [ ! -z "$AUTHPF_USERS" ]; then
                for USER in ${AUTHPF_USERS}; 
                do 
                        KNOWNUSER=`grep "^${USER}:" /etc/passwd`
                        if [ -z "$KNOWNUSER" ]; then
                                DEFAULT_PASSWORD=`${PWDGEN} | /usr/bin/encrypt -b 6`;
                                /usr/sbin/groupadd "${USER}";
                                /usr/sbin/useradd -mv -b /home \
                                -c "${USER}" \
                                -L authpf \
                                -g "${USER}" \
                                -s /usr/sbin/authpf \
                                -p "${DEFAULT_PASSWORD}" \
                                "${USER}";
                                DEFAULT_PASSWORD=""
                        else
                                echo "Known User: $KNOWNUSER"
                        fi
                done
                verify_usercreation ${AUTHPF_USERS}
                copy_sshkeys ${AUTHPF_USERS}
        fi
}
verify_usercreation() {
        for user in $*; 
        do 
            userinfo ${user}; \
            echo "----------------------------------"; \
        done
}
copy_sshkeys() {
        # SSH PUBLIC Keys are expected to be in the `current directory' and in the form
        #  username.pub
        PUB=".pub"

        for USER in $*; 
        do 
                KNOWNUSER=`grep "^${USER}:" /etc/passwd`
                if [ -z "$KNOWNUSER" ]; then
                        echo "Error: Unknown user: $KNOWNUSER"
                else
                        authpf=`echo $USER | awk '{ print index($1, "_authpf") }'`
                        if [ ! -z $authpf ]; then
                                SSHKEY=`echo $USER | awk -F "_authpf" '{ print $1 }'`
                        fi
                        if [ -f ${SSHKEY}${PUB} ]; then
                                cat ${SSHKEY}${PUB} > /home/${USER}/${AUTHORIZED_KEYSFILE}; 
                        fi     
                fi
        done
}
verify_sshkeys() {
        ALL_KEYS=`sudo find /home -name "${AUTHORIZED_KEYSFILE}" -print | grep "${KEYFILE_SUBDIR}"`

        for KEY in ${ALL_KEYS}; 
        do 
                sudo ls -l ${KEY} | awk '{ print  $1,"\t" $5,"\t" $9,"\t" $3 }'  2> /dev/null; 
                USER=`echo ${KEY} | awk -F / '{ print $3 }'`
                if [ -f ${USER}.id_rsa.pub ]; then
                        diff -w ${USER}.id_rsa.pub ${KEY}; 
                fi
                if [ -f ${USER}.pub ]; then
                        diff -w ${USER}.pub ${KEY}; 
                fi         
        done
}
help() {
        echo "User Creation Tool "
        echo "Only slightly worse than tested on OpenBSD"
        OS=`uname`
        if [ ! "${OS}"=="openbsd" ]; then
                echo "Seriously, it only rarely works on OpenBSD"
                exit 1
        fi
        echo "Make sure you have the username.pub ssh public keys"
        echo "in the current directory if you want this script"
        echo "to automatically install them for you"
}
main() {
        help
        create_admins
        create_users
        create_users_authpf
}
main $*