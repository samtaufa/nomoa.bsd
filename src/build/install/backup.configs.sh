#!/bin/sh
# Archive Configuration files using 'tar' or 'gtar' depending on availability
# 
# -- configuration files are specified by line separated text file (no ending `cr')
#     /etc/backup.configs || /etc/syncback.localhost.conf || /etc/syncback.conf
#
#  -- `gtar` supports exclude option, 
#    /etc/backup.configs.exclude || /etc/syncback.localhost.conf.exclude || /etc/syncback.exclude

set_env() {
    PATH=/bin:/usr/bin:/sbin:/usr/sbin
    BACKUP_USER=control
    DST="/var/syncback"
    ostype="unknown"
    OPTIONS="-czpf"
    TAR=/bin/tar
    GTAR=/usr/local/bin/gtar
    HOSTNAME=`/bin/hostname -s`
    TARGETFILE="$DST/$HOSTNAME.tgz"
    
    
    if [ -s /etc/backup.configs ]; then
        INC_FILE=/etc/backup.configs
    elif [ -s /etc/syncback.localhost.conf ]; then
        INC_FILE=/etc/syncback.localhost.conf
    elif [ -s /etc/syncback.conf ]; then
        INC_FILE=/etc/syncback.conf
    else
        echo "ERROR: INCLUDE file does not exist or contain valid data"
        exit 1
    fi
    
    if [ -s /etc/backup.configs.exclude ]; then
        EXC_FILE="-X /etc/backup.configs.exclude"
    elif [ -s /etc/syncback.localhost.exclude ]; then
        EXC_FILE="-X /etc/syncback.localhost.exclude"
    elif [ -s /etc/syncback.exclude ]; then
        EXC_FILE="-X /etc/syncback.exclude"
    else
        echo "ERROR: EXCLUDE file does not exist or contain valid data" >&2
        EXC_FILE=""
    fi

    [[ -x /bin/uname ]] && ostype=`/bin/uname`
    [[ -x /usr/bin/uname ]] && ostype=`/usr/bin/uname`

    umask 027
}


set_destination() {
    if [ ! -d "$DST" ]; then
        mkdir -p "$DST"
        chown root:${BACKUP_USER} "$DST"
        chmod 770 "${DST}"
    fi
}

run_backup() {

    echo -n "Archiving config files for [$HOSTNAME]."
    case $ostype in
        "Linux")
            echo ".on Linux";
            $TAR -T ${INC_FILE} ${EXC_FILE} ${OPTIONS} $TARGETFILE 2> /dev/null
            ;;
        "OpenBSD")
            echo ".on OpenBSD";
            if [ -x $GTAR ]; then
                echo " $GTAR -T ${INC_FILE} ${EXC_FILE} ${OPTIONS} $TARGETFILE"
                $GTAR -T ${INC_FILE} ${EXC_FILE} ${OPTIONS} $TARGETFILE 2> /dev/null
            else
                echo " $TAR -I ${INC_FILE} ${OPTIONS} $TARGETFILE"
                $TAR -I ${INC_FILE} ${OPTIONS} $TARGETFILE 2> /dev/null
            fi
            ;;
        *)
            echo ".Unknown OS - backup failed";
            exit 1;
            ;;
    esac
}
main() {
    set_env
    set_destination
    run_backup
}

main $@
