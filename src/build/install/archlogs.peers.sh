# -- EML Servers
#  Grab Current Syncback Archives

set_env() {
    REMOTE_PATH="/var/syncback"
    LOCAL_PATH="/mnt/logs"
    RSYNC="/usr/local/bin/rsync -av"
    SCP="/usr/bin/scp"
    HOSTNAME=`/bin/hostname -s`

    umask 027
}

info_adelaide() {
    ADLXFW_MASTER=119.225.101.97
    ADLINTFW_MASTER=10.1.0.1
    ADLVPN001=119.225.101.101
    ADLMXP001=119.225.101.99
    ADLMXP002=119.225.101.100
    ADLWAN001=10.1.0.251
    ADLWAN002=10.1.0.252
    SAPROXY=10.1.0.64
    ADLCTL001=10.1.0.24
}
info_georgest() {
    #SYDPROXY=192.168.18.16
    SYDCTL001=192.168.18.63
    SYDINTFW_MASTER=192.168.18.100
    SYDEXTFW_MASTER=202.92.79.105
    SYDMXP001=202.92.79.107
    SYDMXP002=202.92.79.110
    SYDVFW=192.168.18.4
    SYDVPN01=202.92.79.108
    SYDWAN001=192.168.18.251
    SYDWAN002=192.168.18.252
}
info_wif() {
        WIFFW=150.101.200.128
}
function info_pittst {
    PTTWAN_MASTER=192.168.110.253
}
info_parramatta() {
    PMTDSL001=150.101.203.90
    PMTEXTFW=59.167.243.173
    PMTINTFW=59.167.229.210
    PMTVPN=59.167.229.212
    PMTMX=59.167.229.211
    PMTPROXY=192.168.18.16
}
info_gsford() {
    GOSFGW=192.168.25.2
}
info_newcastle() {
    NCLWAN_MASTER="192.168.14.253"
}

sync_hosts() {
    case $HOSTNAME in
    'sydctl001')
        sync_georgest
        sync_pittst
        sync_parramatta
        sync_newcastle
        sync_gosford
        sync_melbourne
        ;;
    'adlctl001')
        sync_adelaide
        ;;
    'pmtwan001'|'pmtwan002')
        sync_parramatta_wan
        ;;
    esac
}
function sync_melbourne {
    PATCH=.logs
    LOCAL_PATH=/mnt/logs
    sync_client 10.5.1.253 vicmelwan001
    sync_client 10.5.1.253 vicmelwan002
}
function sync_pittst {
    info_pittst
    PATCH=.logs
    
    sync_client ${PTTWAN_MASTER} pttwan001
    sync_client ${PTTWAN_MASTER} pttwan002
    
}
sync_newcastle() {
    info_newcastle
    LOCAL_PATH=/mnt/logs
    #~ PATCH=
    
    #~ sync_client ${NCLWAN_MASTER} nclwan001
    #~ sync_client ${NCLWAN_MASTER} nclwan002

    PATCH=.logs
    
    sync_client ${NCLWAN_MASTER} nclwan001
    sync_client ${NCLWAN_MASTER} nclwan002
}
sync_adelaide() {
    info_adelaide
    sync_adelaide_hosts /var/syncback
    sync_adelaide_hosts /mnt/logs .logs
}
sync_adelaide_hosts() {
    LOCAL_PATH=$1
    PATCH=$2
    #sync_client $SAPROXY saproxy01
    sync_client $ADLMXP001 adlmxp001
    sync_client $ADLMXP002 adlmxp002
    sync_client $ADLINTFW_MASTER adlintfw001
    sync_client $ADLINTFW_MASTER adlintfw002
    sync_client $ADLXFW_MASTER adlxfw001
    sync_client $ADLXFW_MASTER adlxfw002
    sync_client $ADLWAN001 adlwan001
    sync_client $ADLWAN002 adlwan002
    #$SCP "$SAVPN:${REMOTE_PATH}/savpn01${PATCH}.tgz" $LOCAL_PATH
    #sync_client $ADLVPN001 adlvpn001
}
sync_client() {
    CLIENTIP="$1"
    CLIENTNAME="$2"
    echo "Synchronise: $2  ${CLIENTIP}:${REMOTE_PATH}/${CLIENTNAME}${PATCH}.tgz"
    $RSYNC "${CLIENTIP}:${REMOTE_PATH}/${CLIENTNAME}${PATCH}.tgz" ${LOCAL_PATH}
}
sync_client_hop() {
	HOP="$1"
	CLIENTIP="$2"
	CLIENTNAME="$3"
    #echo "Synch HOP: ${CLIENTIP}:${REMOTE_PATH}/${CLIENTNAME}${PATCH}.tgz"

    cmdline="${HOP} $RSYNC ${CLIENTIP}:${REMOTE_PATH}/${CLIENTNAME}${PATCH}.tgz ${LOCAL_PATH}"
    echo $cmdline
    ssh -A $cmdline
        
}
sync_georgest() {
    info_georgest
    LOCAL_PATH=/mnt/logs
    PATCH=.logs
    sync_client 192.168.18.4 sydvfw001
    sync_client 192.168.18.11 sydintfw01
    sync_client 192.168.18.12 sydintfw02
    #sync_client 192.168.18.16 sydproxy01
    sync_client 192.168.18.251 sydwan001
    sync_client 192.168.18.252 sydwan002
    # -- DMZ Clients
    sync_client 202.92.79.107 sydmxp001
    sync_client 202.92.79.110 sydmxp002
    sync_client 202.92.79.105 sydextfw01
    sync_client 202.92.79.105 sydextfw02
    sync_client 202.92.79.108 sydvpn01
}

function sync_parramatta_wan {
    # -- From the Parramatta WAN Gateway to DR DMZ (100 is DR Internal Firewall)
    LOCAL_PATH=/var/syncback
    PATCH=.logs
	sync_client_hop 172.16.104.100 59.167.229.209 pmtextfw001
	sync_client_hop 172.16.104.100 59.167.229.211 pmtmxp001
    sync_client 172.16.104.100 pmtintfw001
    sync_client 172.16.104.100 pmtextfw001
    sync_client 172.16.104.100 pmtmxp001

    LOCAL_PATH=/var/syncback
    PATCH=
	sync_client_hop 172.16.104.100 59.167.229.209 pmtextfw001
	sync_client_hop 172.16.104.100 59.167.229.211 pmtmxp001
    sync_client 172.16.104.100 pmtintfw001
    sync_client 172.16.104.100 pmtextfw001
    sync_client 172.16.104.100 pmtmxp001
}
function sync_parramatta {
    LOCAL_PATH=/mnt/logs
    PATCH=.logs
    sync_client 192.168.24.253 pmtwan001
    sync_client 192.168.24.253 pmtwan002
    sync_client 192.168.24.253 pmtextfw001
    sync_client 192.168.24.253 pmtintfw001
    sync_client 192.168.24.253 pmtmxp001
}
sync_gosford() {
    info_gsford

    LOCAL_PATH=/mnt/logs
    PATCH=.logs
    sync_client ${GOSFGW} goswan001
    sync_client ${GOSFGW} goswan002
}

chk_disk() {
        if [ ! -d $LOCAL_PATH ]; then
                mkdir -p "${LOCAL_PATH}"
        fi
}
main() {
        set_env
        eval `ssh-agent 2> /dev/null` ssh-add 2>&1 > /dev/null

        sync_hosts
        
        kill $SSH_AGENT_PID 2>&1 > /dev/null
}

main $@
