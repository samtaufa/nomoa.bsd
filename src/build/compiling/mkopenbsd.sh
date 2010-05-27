#!/bin/ksh

# Generic build scripts for building OpenBSD from source
# Benefits:
#
#
# Testing ISO (FAQ14)
#	vnconfig svnd0 ISOPATH
#      mount -t cd9660 /dev/svnd0c /MNT_ISO
#
#      umount /MNT_ISO
#      vnconfig -u svnd0
#
# Burning ISO
#     /usr/local/bin/cdrecord dev=/dev/cd0c -v -tao -data -eject ISOPATH
set +u
APPNAME=$0

function set_env {
    USERNAME=samt
    CVSHOST=192.168.21.202
    DIRECTORY=/var/CVSROOT/openbsd
    CVSROOT=$USERNAME@$CVSHOST:$DIRECTORY
    MYIP_ADDR=`ifconfig | grep inet | grep -v inet6 | grep -v 127.0.0.1 | awk '{print $2}'  | sed s"/addr://" | awk '{ print $1 }'`
    for ipaddr in $MYIP_ADDR; do
        if [ $ipaddr  = $CVSHOST ]; then
            CVSROOT=$DIRECTORY
        fi
    done
    CVSROOT=$DIRECTORY

    OSREV=`uname -a | awk '{print $3 }'`
    BUILDREV=`echo ${OSREV} | sed s'/\./_/g'`
    REVISO=`echo ${OSREV} | sed s'/\.//g'`
    BUILDVER="OPENBSD_$BUILDREV"
    MACHINE=`uname -a | awk '{ print $5 }'`
    KERNEL="GENERIC"

    cvs_BASE=/usr
    cvs_EXPORTDIR=$cvs_BASE/dest/distrib

    checkoutLIST="src ports xenocara"
    updateLIST="src xenocara"
    exportLIST="src ports xenocara"
    exportLIST=""
    buildLIST="src xenocara"
    releaseLIST="src xenocara"

    DESTBASEDIR=$cvs_BASE/dest/base
    RELEASEBASEDIR=$cvs_BASE/rel/base
    SRCRELEASE=$cvs_BASE/rel/src
    DESTXENDIR=$cvs_BASE/dest/xen
    RELEASEXENDIR=$cvs_BASE/rel/xen

    # CD BUILD Configuration Info
    STAGING_DIR="/var/tmp/staging"
    CDDIR=${STAGING_DIR}/cd-dr
    STATE=stable.`date "+%Y%m%d"`
    PACKAGE_SRC=$cvs_BASE/ports/packages/${MACHINE}/all
    PACKAGE_DST="${CDDIR}/${OSREV}/packages/${MACHINE}"
    PUBLISHER="Employers Mutual Ltd"
    PREPAIRER="EML, http://www.employersmutual.com.au, info@employersmutual.com.au"
    MNT_ISO=/mnt/iso
    # Launch options
    oCheckout=0
    oUpdate=0
    oExport=0
    oBuild=0
    oRelease=0
    oMkiso=0
    oTestIso=0
}
function set_paths {
    mkdir -p $STAGING_DIR
    mkdir -p ${CDDIR}/${OSREV}/${MACHINE}
    mkdir -p ${CDDIR}/${OSREV}/packages/${MACHINE}
	mkdir -p ${CDDIR}/.buildinfo
}
function appusage {
        echo "Useage: $APPNAME [ options ]"
        echo ""
        echo "Manage your OpenBSD Source Builds"
        echo ""
        echo "-?|-h|--help This help screen"
        echo "-b|--build [kernel|src|xenocara] make build LIST"
        echo "-c|--checkout [src|ports|xenocara] cvs checkout LIST "
        echo "-m|--mkiso   create an ISO image from the 'release' build"
        echo "-r|--release [src|xenocara]  make build release"
        echo "-t|--testiso mount the iso for testing"
        echo "-u|--update [src|ports|xenocara] cvs update LIST"
        echo "-x|--export [src|ports|xenocara] cvs export LIST"
        echo ""
        echo "--all   : same as --update, --export, --build, --release, --mkiso, --testiso"        
        echo ""
        echo "LIST  is a sequence of options (quoted) such as \"ports src xenocara\""
        echo ""
        echo ""
        
}
function get_options {
    if [ $# -eq 0 ]; then
            appusage
            exit 1
    fi
    while [ $# -gt 0 ]
    do
            case "$1" in
                    '-c'|'--checkout') 
                            PARAM2=`echo $2 | awk '{ print substr($1,1,1) }'`
            if [ ! -z "$PARAM2" -a ! "X$PARAM2" = "X-" ]; then
                checkoutLIST=""
                while [  ! -z "$PARAM2" -a ! "$PARAM2" = "-" ]
                do
                    checkoutLIST="$checkoutLIST $2"
                    shift
                    PARAM2=`echo $2 | awk '{ print substr($1,1,1) }'`
                done
            fi
            oCheckout=1
                            ;;
                    '-u'|'--update') 
                            PARAM2=`echo $2 | awk '{ print substr($1,1,1) }'`
            if [ ! -z "$PARAM2" -a ! "X$PARAM2" = "X-" ]; then
                updateLIST=""
                while [  ! -z "$PARAM2" -a ! "$PARAM2" = "-" ]
                do
                    updateLIST="$updateLIST $2"
                    shift
                    PARAM2=`echo $2 | awk '{ print substr($1,1,1) }'`
                done
            fi
            oUpdate=1
                            ;;
                    '-x'|'--export') 
                            PARAM2=`echo $2 | awk '{ print substr($1,1,1) }'`
            if [ ! -z "$PARAM2" -a ! "X$PARAM2" = "X-" ]; then
                exportLIST=""
                while [  ! -z "$PARAM2" -a ! "$PARAM2" = "-" ]
                do
                    exportLIST="$exportLIST $2"
                    shift
                    PARAM2=`echo $2 | awk '{ print substr($1,1,1) }'`
                done
            fi
            oExport=1
                            ;;
                    '-b'|'--build') 
                            PARAM2=`echo $2 | awk '{ print substr($1,1,1) }'`
            if [ ! -z "$PARAM2" -a ! "X$PARAM2" = "X-" ]; then
                buildLIST=""
                while [  ! -z "$PARAM2" -a ! "$PARAM2" = "-" ]
                do
                    buildLIST="$buildLIST $2"
                    shift
                    PARAM2=`echo $2 | awk '{ print substr($1,1,1) }'`
                done
            fi
                            oBuild=1
                            ;;
                    '-r'|'--release') 
                            PARAM2=`echo $2 | awk '{ print substr($1,1,1) }'`
            if [ ! -z "$PARAM2" -a ! "X$PARAM2" = "X-" ]; then
                releaseLIST=""
                while [  ! -z "$PARAM2" -a ! "$PARAM2" = "-" ]
                do
                    releaseLIST="$releaseLIST $2"
                    shift
                    PARAM2=`echo $2 | awk '{ print substr($1,1,1) }'`
                done
            fi
                            oRelease=1
                            ;;
        '-t'|'--testiso')
            oTestIso=1
            ;;
                    '-m'|'--mkiso') 
                            oMkiso=1
                            ;;
                    '-a'|'--all')
                            oUpdate=1
                            oExport=1
                            oBuild=1
                            oRelease=1
                            oMkiso=1
            oTestIso=1
                            ;;
                    '-?'|'-h'|'--help'|*)
                            appusage
                            exit 1
                            ;;
            esac
            shift
    done
}
function cvs_checkout {
    cd $cvs_BASE
    echo ">>>CVS Checking out $CVSROOT $BUILDVER"
    echo "   $checkoutLIST"
    REPORT="${STAGING_DIR}/.cvs.checkout"
    REPORT_ERR="$REPORT.err"
	case ${OSREV} in
		'4.3'|'4.2'|'4.1'|'4.0'|'3.9') 
			CVSAPP=cvs
			;;
		*)	CVSAPP=opencvs
			;;
	esac
    $CVSAPP -d ${CVSROOT} checkout -r$BUILDVER -P $checkoutLIST > "$REPORT" 2> "$REPORT_ERR"
    echo "(done)" >> "$REPORT" 2> "$REPORT_ERR"
}

function cvs_update {
    echo ">>>CVS updating [$updateLIST]"
    REPORT="$STAGING_DIR/.cvs.update.txt"
    REPORT_ERR="${REPORT}.err"
	case ${OSREV} in
		'4.4'|'4.3'|'4.2'|'4.1'|'4.0'|'3.9') 
			CVSAPP=cvs
			;;
		*)	CVSAPP=opencvs
			;;
	esac
	
    for subdir in $updateLIST; do
        echo "   $subdir ..."
        REPORT="${REPORT}.$subdir"
        cd $cvs_BASE/$subdir;
        $CVSAPP -d${CVSROOT} update -Pd > "$REPORT" 2> "$REPORT_ERR"
        echo "(done)" >> "$REPORT" 
    done
}

function cvs_export {
    echo ">>>CVS Export for Src Distribution: [${cvs_EXPORTDIR}]"
    if [ -z "${cvs_EXPORTDIR}" -o "${cvs_EXPORTDIR}" == "/" ]; then
        echo "ERROR: invalid value for src distribution dir: [${cvs_EXPORTDIR}]"
        exit 1
    fi
    
    echo "   [${cvs_EXPORTDIR}] clearing source export directory"
	test -d ${cvs_EXPORTDIR}.old && rm -rf "${cvs_EXPORTDIR}.old"
    test -d ${cvs_EXPORTDIR} && mv ${cvs_EXPORTDIR} ${cvs_EXPORTDIR}.old 
	rm -rf "${cvs_EXPORTDIR}.old" &
        
    echo "   [${SRCRELEASE}] clearing tgz source release directory"
	test -d ${SRCRELEASE}.old && rm -rf "${SRCRELEASE}.old"
    test -d ${SRCRELEASE} && mv ${SRCRELEASE} ${SRCRELEASE}.old 
	rm -rf "${SRCRELEASE}.old" &

	sleep 5
	
	mkdir -p ${SRCRELEASE}
	if [ ! -d  ${SRCRELEASE} ]; then
		echo "Error Making ${SRCRELEASE} "
		exit 1
	fi
	mkdir -p ${cvs_EXPORTDIR}
	if [ ! -d  ${cvs_EXPORTDIR} ]; then
		echo "Error Making ${cvs_EXPORTDIR} "
		exit 1
	fi
        
    cd ${cvs_EXPORTDIR}
	case ${OSREV} in
		'4.3'|'4.2'|'4.1'|'4.0'|'3.9') CVSAPP=cvs
			;;
		*)	CVSAPP=opencvs
			;;
	esac

    REPORT="$STAGING_DIR/.cvs.export"

    for BRANCH in ${exportLIST}; do
        echo -n "   exporting ${BRANCH} ..."
        REPORT="${REPORT}.${BRANCH}.txt"
        REPORT_ERR="${REPORT}.err"
        $CVSAPP -d$CVSROOT -q export -r$BUILDVER -d ${BRANCH} ${BRANCH} > "$REPORT" 2> "$REPORT_ERR"
        echo " . archiving (tgz)"
        if [ "X${BRANCH}" == "Xports" -o "X${BRANCH}" == "Xxenocara"  ]; then
            tar -zcf ${SRCRELEASE}/${BRANCH}.tgz ${BRANCH} >> "$REPORT" 2>> "$REPORT_ERR"
        fi
        if [ "X${BRANCH}" == "Xsrc" ]; then
            cd ${BRANCH}
            tar -zcf ${SRCRELEASE}/${BRANCH}.tgz . >> "$REPORT" 2> "$REPORT_ERR"                      
            cd ${cvs_EXPORTDIR}
        fi
        echo "(done)" >> "${REPORT}" 
    done
}

function bld_kernel {
    echo ">>>Building Kernel: $KERNEL"
    REPORT="$STAGING_DIR/.bld.kernel.txt"
    REPORT_ERR="${REPORT}.err"
	if [ ! -z "$KERNEL" ]; then
		rm -rf "$cvs_BASE/src/sys/arch/${MACHINE}/compile/$KERNEL"
	fi
    cd $cvs_BASE/src/sys/arch/${MACHINE}/conf
    config $KERNEL
    cd ../compile/$KERNEL
    make clean  > "${REPORT}" 2> "${REPORT}.err" \
            && make depend  >> "${REPORT}" 2> "${REPORT_ERR}" \
            && make >> "${REPORT}" 2> "${REPORT_ERR}"
    echo "   installing kernel"
    make install >> "${REPORT}" 2> "${REPORT_ERR}"
    echo "(done)" >> "${REPORT}" 2> "${REPORT_ERR}" 
	echo "KERNEL BUILD COMPLETE - REBOOT RECOMMENDED"
	echo ""
	echo "Verify Kernel Build [$REPORT]"
	echo "Ctrl+C and reboot, or Enter to ignore my advice"
	sleep 180
}

function bld_userland {
    echo ">>>Building USERLAND"
    echo "   rm -rf $cvs_BASE/obj/*"
    REPORT="$STAGING_DIR/.bld.userland.txt"
    REPORT_ERR="${REPORT}.err"
	cd $cvs_BASE/obj && mkdir -p .old && sudo mv * .old &&\
    sudo rm -rf .old &
    cd $cvs_BASE/src
    echo "   make obj"
    make obj > "${REPORT}" 2> "${REPORT_ERR}"

    echo "   make distrib-dirs"        
    cd $cvs_BASE/src/etc && env DESTDIR=/ make distrib-dirs  >> "${REPORT}" 2> "${REPORT_ERR}"
    cd $cvs_BASE/src
    echo "   make build (compiles and install all 'userland' utilities in the appropriate order)"
    make build  >> "${REPORT}" 2> "${REPORT_ERR}"
    echo "(done)" >> "${REPORT}" 2> "${REPORT_ERR}"
}

function rel_base {
    echo ">>>Building RELEASE BASE: $BUILDVER"
    REPORT="$STAGING_DIR/.bld.crunchgen.txt"
    REPORT_ERR="${REPORT}.err"
    if [ ! -d $cvs_BASE/src ]; then
            "Base src not availabe [${cvs_BASE}/src"
            exit 1
    fi
	
	case ${REVISO} in
		44|43|42|41|40|39) 
			echo "   build crunchgen"
			cd $cvs_BASE/src/distrib/crunch && make obj depend all install  > "${REPORT}" 2> "${REPORT_ERR}"
			;;
	esac

	export DESTDIR=${DESTBASEDIR} ; export RELEASEDIR=${RELEASEBASEDIR}
        echo "   [${DESTDIR}] clear old destdir "
	OLD=${DESTDIR}.old
	test -d ${OLD} && rm -rf ${OLD}
        test -d ${DESTDIR} && mv ${DESTDIR} ${OLD} 
	rm -rf ${OLD} &
	mkdir -p ${DESTDIR}
	if [ ! -d  ${DESTDIR} ]; then
		echo "Failed to mkdir [${DESTDIR}]"
		exit 1
	fi
	
        #~ echo "   [$RELEASEBASEDIR] clear old releasedir "
	#~ test -d ${RELEASEDIR}.old && rm -rf ${RELEASEDIR}.old
        #~ test -d ${RELEASEDIR} && mv ${RELEASEDIR} ${RELEASEDIR}.old 
	#~ rm -rf ${RELEASEDIR}.old &
	
	mkdir -p ${RELEASEDIR}
	if [ ! -d  ${RELEASEDIR} ]; then
		echo "Failed to mkdir [${RELEASEDIR}]"
		exit 1
	fi

    echo "   make release"
    REPORT="$STAGING_DIR/.rel.base.txt"
    REPORT_ERR="${REPORT}"
    cd $cvs_BASE/src/etc
    make release > "${REPORT}" 2> "${REPORT_ERR}"
    echo "(done)" >> "${REPORT}" 2> "${REPORT_ERR}"

    echo "   verify distrib/sets"
    REPORT="${STAGING_DIR}/.bld.base.checklist.txt"
    REPORT_ERR="${REPORT}.err"
    cd $cvs_BASE/src/distrib/sets && sh checkflist > "${REPORT}" 2> "${REPORT_ERR}"
    echo "(done)" >> "${REPORT}" 2> "${REPORT_ERR}"
}

function bld_xenocara {
        echo ">>>Building XENOCARA"
        REPORT="${STAGING_DIR}/.bld.xenocara"
        REPORT_ERR="${REPORT}"
        if [ ! -d $cvs_BASE/xenocara ]; then
                "Xenocara src not available"
                exit 1
        fi
	
        cd $cvs_BASE/xenocara
        echo "   rm -rf $cvs_BASE/xobj/*"
        rm -rf $cvs_BASE/xobj/*
        echo "   make bootstrap"
        make bootstrap  > "${REPORT}.bootstrap.txt" 2> "${REPORT_ERR}.bootstrap.txt.err"
        echo "   make obj"
        make obj  > "${REPORT}.obj.txt" 2> "${REPORT_ERR}.obj.txt.err"
        echo "   make build"
        make build  > "${REPORT}.txt" 2> "${REPORT_ERR}.txt.err"
        echo "(done)" >> "${REPORT}" 2> "${REPORT_ERR}"
}

function rel_xenocara {
    cd $cvs_BASE/xenocara
    echo ">>>Building RELEASE XENOCARA: $BUILDVER"
    REPORT="$STAGING_DIR/.rel.xenocara.txt"
    REPORT_ERR="${REPORT}.err"
    echo -n "   clear old dest [$DESTXENDIR]"
	export DESTDIR=${DESTXENDIR} ; export RELEASEDIR=${RELEASEXENDIR}	
	OLD=${DESTDIR}.old
	test -d ${OLD} && rm -rf ${OLD}
        test -d ${DESTDIR} && mv ${DESTDIR} ${OLD}
	rm -rf ${OLD} &
	mkdir -p ${DESTDIR}
	
	if [ ! -d ${DESTDIR} ]; then
		echo "Failed to mkdir [${DESTDIR}]"
		exit 1
	else
		test -d ${DESTDIR} && echo "   created [${DESTDIR}]"
	fi
				
	mkdir -p "${RELEASEDIR}"
	if [ ! -d ${RELEASEDIR} ]; then
		echo "Failed to mkdir [${RELEASEDIR}]"
		exit 1
	else
		test -d ${RELEASEDIR} && echo "   created [${RELEASEDIR}]"
	fi
		
    echo "   make release"
    cd $cvs_BASE/xenocara
    make release > "${REPORT}" 2> "${REPORT_ERR}"
    echo "(done)" >> "${REPORT}" 2> "${REPORT_ERR}"
}
function iso_layout {
    echo ">>>AGGREGATING CD Content - Builds"
        
	rm -rf ${CDDIR}/${OSREV}/${MACHINE}
	rm -rf ${CDDIR}/${OSREV}/packages/${MACHINE}
	
	mkdir -p ${CDDIR}/${OSREV}/${MACHINE}
	mkdir -p ${CDDIR}/${OSREV}/packages/${MACHINE}
	mkdir -p ${CDDIR}/.buildinfo
	mkdir -p ${CDDIR}/etc
	echo "set image /${OSREV}/${MACHINE}/bsd.rd" > ${CDDIR}/etc/boot.conf
	
	mv ${STAGING_DIR}/.* ${CDDIR}/.buildinfo

    if [ -d "$RELEASEBASEDIR" ]; then
        echo "   copying $RELEASEBASEDIR"
        cp -p $RELEASEBASEDIR/* ${CDDIR}/${OSREV}/${MACHINE}
    fi
    if [ -d "$RELEASEXENDIR" ]; then
        echo "   copying $RELEASEXENDIR"
        cp -p $RELEASEXENDIR/* ${CDDIR}/${OSREV}/${MACHINE}
    fi

    echo "   Source Distributions"
    if [ ! -z "${SRCRELEASE}" ]; then
        if [ -f ${SRCRELEASE}/ports.tgz ]; then
            echo "   - ports"
            cp -p ${SRCRELEASE}/ports.tgz ${CDDIR}/${OSREV}/
        fi
        if [ -f ${SRCRELEASE}/src.tgz ]; then
            echo "   - src"
            cp -p ${SRCRELEASE}/src.tgz ${CDDIR}/${OSREV}/
        fi
        if [ -f ${SRCRELEASE}/xenocara.tgz ]; then
            echo "   - xenocara"
            cp -p ${SRCRELEASE}/xenocara.tgz ${CDDIR}/${OSREV}/
        fi
    fi        
}

function iso_packages_base {
    # Base - default install
    PKGS="bzip2 colorls curl gettext gnupg gnuwatch libdnet libiconv"
    PKGS="$PKGS libidn lua- lzo- multitail mutt nmap- pcre- pstree python qdbm rsync"
    PKGS="$PKGS sqlite3 screen vim wget zsh libtool gmake"

    # Base - Benchmarking
    PKGS="$PKGS blogbench bonnie bytebench iogen lmbench netperf netpipe"
    PKGS="$PKGS netstrain pear-Benchmark randread smtp-benchmark"
    PKGS="$PKGS stress sysbench tcpblast ubench xengine"
    PKGS="$PKGS libxslt libgcrypt libgpg py-libxml mysql-client mysql-server"
    iso_packages_copy        
}
function iso_packages_mailserver {
    # Mail Proxy Servers
    PKGS="postfix dovecot pflogsumm "
    PKGS="$PKGS p5-Date-Calc p5-Bit-Vector p5-Carp-Clan"
    iso_packages_copy
}
function iso_packages_monitorbox {
    # Monitoring Host 
    PKGS="procmail fetchmail php5 smstools"

    PKGS="$PKGS nagios nrpe glib2- libltdl-"
    PKGS="$PKGS scanssh scanlogd smokeping nepenthes mysql "

    PKGS="$PKGS  mod_"

    PKGS="$PKGS  p5-ldap p5-Config-Grammar fping p5-Net-DNS p5-Convert-ASN"
    PKGS="$PKGS p5-Net-Telnet p5-SNMP_Session rrdtool p5-Authen-Radius p5-Authen-SASL"
    PKGS="$PKGS p5-Digest-HMAC p5-CGI-SpeedyCGI p5-libwww p5-Digest-SHA1 p5-GSSAPI"
    PKGS="$PKGS p5-IO-Socket-SSL p5-Net-SSLeay p5-XML-Parser p5-XML-SAX-Writer p5-Text-Iconv"
    PKGS="$PKGS p5-XML-Filter-BufferText p5-XML-SAX p5-XML-NamespaceSupport p5-URI"
    PKGS="$PKGS p5-Net-IP p5-RRD libart- png- p5-MD5 p5-Compress- p5-IO-Compress-"
    PKGS="$PKGS p5-Crypt- p5-HTML- p5-HTTP- libghttp"
    iso_packages_copy
}
function iso_packages_git {
        PKGS="git p5-Error-"
        iso_packages_copy
}
function iso_packages_optional {
    # web proxy
    PKGS="squid"

    # Other
    PKGS="$PKGS cyrus-sasl  openldap openvpn p5-Bit-Vector"
    PKGS="$PKGS minicom kermit lrzsz zmtx-zmrx cdrtools"
    iso_packages_copy

    # Firewall
    PKGS="trafshow tcpflow tcpstat pftop pfstat hatchet"
    iso_packages_copy
}
function iso_packages_copy {
    for package in $PKGS; do
        echo -n "$package ";
        cp -f ${package}* "$PACKAGE_DST" >> "$STAGING_DIR/.iso.packages.txt" 2>> "$STAGING_DIR/.iso.packages.err.txt" 
    done
}
function iso_packages {
    if [ ! -d "$PACKAGE_SRC" -o ! -d "$PACKAGE_DST" ]; then
            echo "package path not found [$PACKAGE_SRC] or ${PACKAGE_DST}"
            exit 1
    fi

    echo ">>>AGGREGATING Package Collection"
    cd $PACKAGE_SRC

    iso_packages_base
    iso_packages_mailserver
    iso_packages_monitorbox
    iso_packages_optional
    iso_packages_git
}
function iso_buildimage {
	echo ""
        echo ">>>ISO BUILD"
	#iso_mkiso
	iso_mkhybrid
}
function iso_mkiso {
    cd ${CDDIR}
	ISOFILE=${CDDIR}/../openbsd${REVISO}_${MACHINE}.${STATE}.iso
    echo "   mkiso"
    mkisofs -rvTV "OpenBSD${REVISO} ${MACHINE} $STATE" \
        -no-emul-boot \
        -b ${OSREV}/${MACHINE}/cdbr -c boot.catalog \
        -o ${ISOFILE} \
        -A "OpenBSD Build Install CD" \
        -p "$PREPAIRER" \
        -P "$PUBLISHER" \
        -publisher "$PUBLISHER" \
        ${CDDIR} \
         > "$STAGING_DIR/.mkiso.build.txt" 2> "$STAGING_DIR/.mkiso.build.err.txt" 
}
function iso_mkhybrid {
        echo "   mkhybrid"
	cd ${CDDIR}
	ISOFILE=${CDDIR}/../openbsd${REVISO}_${MACHINE}.${STATE}.iso
	mkhybrid -a -R -T -L -l -d -D -N \
		-b ${OSREV}/${MACHINE}/cdbr -c boot.catalog \
		-o ${ISOFILE} -v -v \
		-A "OpenBSD ${OSREV} ${MACHINE} Install CD" \
		-P "$PUBLISHER" \
		-p "$PREPAIRER" \
		-V "OpenBSD/${MACHINE} ${OSREV} Install CD" \
		. \
         > "$STAGING_DIR/.mkhybrid.build.txt" 2> "$STAGING_DIR/.mkhybrid.build.err.txt" 
}
function cvs_getfiles {
    if [ $oCheckout -eq 1 ]; then
            cvs_checkout
    fi
    if [ $oExport -eq 1 ]; then
            cvs_export
    fi
    if [ $oUpdate -eq 1 ]; then
            cvs_update
    fi
}
function build_binaries {
    if [ $oBuild -eq 1 ]; then
        for target in $buildLIST; do
            case $target in
            'kernel') bld_kernel
                    ;;
            'src') 	bld_userland
                    ;;
            'xenocara') bld_xenocara
                    ;;
            *) echo "Somethings Broken"
                exit 1
                ;;
            esac
        done
    fi
}
function build_release {
    if [ $oRelease -eq 1 ]; then	
    for target in $releaseLIST; do
        case $target in
            'src') rel_base
                ;;
            'xenocara') rel_xenocara
                ;;
            *) echo "Somethings broken"
                exit 1
                ;;
        esac
    done
    fi
}
function iso_test {

	ISO="$STAGING_DIR/openbsd${REVISO}_${MACHINE}.${STATE}.iso"
	if [ ! -f ${ISO} ]; then
		ISO="$STAGING_DIR/openbsd${REVISO}_${MACHINE}.${STATE}.mkhybrid.iso"
	fi
	if [ -f  ${ISO} -a ! -z ${MNT_ISO} ]; then
	
		if [ ! -d ${MNT_ISO} ]; then
			mkdir ${MNT_ISO}
		fi
		umount ${MNT_ISO}
		vnconfig -u svnd3 
		
		echo "Mount Point [${MNT_ISO}] for ISO [${ISO}]"
		vnconfig -c svnd3 ${ISO}
		mount -t cd9660 /dev/svnd3c ${MNT_ISO}
		echo "REMEMBER: remove mount when you are finished"
		echo "          # umount ${MNT_ISO}"
		echo "          # vnconfig -u svnd3"
	fi
}
function iso_build {
    if [ $oMkiso -eq 1 ]; then
            iso_layout
            iso_packages
            iso_buildimage
    fi
	if [ $oTestIso -eq 1 ]; then
		iso_test
	fi
}
function main {
    set_env
    get_options "$@"
    
	if [ ! -z ${CDDIR} -a -d ${CDDIR} ]; then
		rm -rf "${CDDIR}"
	fi
    set_paths

    cvs_getfiles
    build_binaries
    build_release
    iso_build
}

main $@
