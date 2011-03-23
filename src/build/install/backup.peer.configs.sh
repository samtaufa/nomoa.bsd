#!/bin/sh
# 
# Use for synchronising peers

set_env() {
    umask 027
    HOSTNAME=`/bin/hostname -s`
    RSYNC="/usr/local/bin/rsync"
    SYNCPATH="/var/syncback/"
    CONFIG="/etc"
    
}
set_peerinfo() {
    # Configuration Files containing peer IP and peer HOSTPEER

    if [ -f /etc/backup.peer.ip ]; then
        SRC_IP=`head -1 $CONFIG/backup.peer.ip`
    elif [ -f /etc/syncback.peer.ip ]; then
        SRC_IP=`head -1 $CONFIG/syncback.peer.ip`
    elif [ -f /etc/syncpeer.ip ]; then
        SRC_IP=`head -1 $CONFIG/syncpeer.ip `
    elif [ -f /etc/syncpeer ]; then
        SRC_IP=`head -1 $CONFIG/syncpeer`
    else
        echo "Can't determine PEER IP"
        exit 1
    fi
    
    if [ -f /etc/backup.peer.name ]; then
        HOSTPEER=`head -1 /etc/backup.peer.name`
    elif [ -f /etc/syncback.peer.hostname ]; then
        HOSTPEER=`head -1 /etc/syncback.peer.hostname`
    elif [ -f /etc/synchost ]; then
        HOSTPEER=`head -1 /etc/synchost`
    else
        echo "Can't determine PEER HOSTNAME"
        exit 1
    fi
}

sync_peer() {
    $RSYNC -av $SRC_IP:$SYNCPATH/$HOSTPEER.tgz $SYNCPATH
    $RSYNC -av $SRC_IP:$SYNCPATH/$HOSTPEER.logs.tgz $SYNCPATH
}

main() {
    set_env
    eval `ssh-agent 2> /dev/null` ssh-add 2>&1 > /dev/null

    case ${HOSTNAME} in
       'pmtextfw01')
            $RSYNC -av "59.167.229.210:$SYNCPATH/*" $SYNCPATH
            $RSYNC -av "59.167.229.211:$SYNCPATH/*" $SYNCPATH
            $RSYNC -av "59.167.229.212:$SYNCPATH/*" $SYNCPATH
            ;;
        *)
            set_peerinfo
            sync_peer
            ;;
    esac
    
    kill $SSH_AGENT_PID 2>&1 > /dev/null
    
}

main $@