#!/bin/ksh

# Generic build scripts for building OpenBSD from source
# Benefits:
#
#
# Testing ISO (FAQ14)
#	vnconfig svnd0 ISOPATH
#      mount -t cd9660 /dev/svnd0c /MOUNTPOINT
#
#      umount /MOUNTPOINT
#      vnconfig -u svnd0
#
# Burning ISO
#     /usr/local/bin/cdrecord dev=/dev/cd0c -v -tao -data -eject ISOPATH
set +u
APPNAME=$0
USERNAME=samt
HOSTNAME=`/bin/hostname -s`
#~ CVSHOST=192.168.21.68
DIRECTORY=/var/CVSROOT/openbsd
case $HOSTNAME in
    'b48b') DIRECTORY=/var/data/CVSROOT/openbsd
            ;;
    'b48') DIRECTORY=/var/CVSROOT/openbsd
esac

#~ CVSROOT=$USERNAME@$CVSHOST:$DIRECTORY
#~ MYIP_ADDR=`ifconfig | grep inet | grep -v inet6 | grep -v 127.0.0.1 | awk '{print $2}'  | sed s"/addr://" | awk '{ print $1 }'`
#~ for ipaddr in $MYIP_ADDR; do
	#~ if [ $ipaddr  = $CVSHOST ]; then
		#~ CVSROOT=$DIRECTORY
	#~ fi
#~ done
CVSROOT=$DIRECTORY

OSREV=`/usr/bin/uname -r`
BUILDREV=`echo ${OSREV} | sed s'/\./_/g'`
ISOREV=`echo ${OSREV} | sed s'/\.//g'`
BUILDVER="OPENBSD_$BUILDREV"
MACHINE=`/usr/bin/uname -m`
KERNEL="GENERIC"

cvs_BASE=/usr
XSRCDIR=${cvs_BASE}/xenocara
cvs_EXPORTDIR=$cvs_BASE/dest/export

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
REP_DIR="/var/tmp/staging"
CDBUILD=${REP_DIR}/cd-build
STATE=stable.`date "+%Y%m%d"`
PACKAGE_SRC=$cvs_BASE/ports/packages/${MACHINE}/all
if [ -d /var/openbsd/${OSREV}/packages/${MACHINE} ]; then
    PACKAGE_SRC=/var/openbsd/${OSREV}/packages/${MACHINE}
fi
PACKAGE_DST="${CDBUILD}/${OSREV}/packages/${MACHINE}"
MOUNTPOINT=/mnt.iso
# Launch options
oCheckout=0
oUpdate=0
oExport=0
oBuild=0
oRelease=0
oMkiso=0
oTestIso=0
oBldiso=0

appusage() {
        echo "Useage: $APPNAME [ options ]"
        echo ""
        echo "Manage your OpenBSD Source Builds"
        echo ""
        echo "-?|-h|--help This help screen"
        echo "-b|--build [kernel|src|xenocara] make build LIST"
        echo "-c|--checkout [src|ports|xenocara] cvs checkout LIST "
        echo "-m|--mkiso   create an ISO image from the 'release' build and packages"
        echo "-i|--iso     Build ISO image from existing --mkiso configurations"
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
get_options() {
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
                        '-i'|'--iso') 
                                oBldiso=1
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
cvs_checkout() {
    cd $cvs_BASE
    echo ">>>CVS Checking out $CVSROOT $BUILDVER"
    LOGFILE="$REP_DIR/.cvs.checkout"
    echo "   $checkoutLIST"
	case ${OSREV} in
		'4.8'|'4.7'|'4.6'|'4.5'|'4.4'|'4.3'|'4.2'|'4.1'|'4.0'|'3.9') 
			CVSAPP=/usr/bin/cvs
			;;
		*)	CVSAPP=/usr/bin/cvs
            if [ -x /usr/bin/opencvs ]; then
                CVSAPP=/usr/bin/opencvs
            fi
			;;
	esac
    $CVSAPP -d ${CVSROOT} checkout -r $BUILDVER -P $checkoutLIST > "$LOGFILE.txt" 2> "$LOGFILE.err.txt"
    check_error $?
    echo "(done)" >> "$LOGFILE.txt"
    echo "(done)" >> "$LOGFILE.err.txt"
}

cvs_update() {
    echo ">>>CVS updating [$updateLIST]"
    LOGFILE="$REP_DIR/.cvs.update"
	case ${OSREV} in
		'4.8'|'4.7'|'4.6'|'4.5'|'4.4'|'4.3'|'4.2'|'4.1'|'4.0'|'3.9') 
			CVSAPP=/usr/bin/cvs
			;;
		*)	CVSAPP=/usr/bin/cvs
            if [ -x /usr/bin/opencvs ]; then
                CVSAPP=/usr/bin/opencvs
            fi
			;;
	esac
	
    for subdir in $updateLIST; do
        echo "   $subdir ..."
        cd $cvs_BASE/$subdir;
        $CVSAPP -d${CVSROOT} update -Pd > "$LOGFILE.$subdir.txt" 2> "$LOGFILE.$subdir.err.txt"
        check_error $?
        echo "(done)" >> "$LOGFILE.$subdir.txt"
        echo "(done)" >> "$LOGFILE.$subdir.err.txt"
    done
}

cvs_export() {
    echo ">>>CVS Export for Src Distribution: [${cvs_EXPORTDIR}]"
    LOGFILE="$REP_DIR/.cvs.export"
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
    check_error $? "Error Making ${SRCRELEASE} "
	mkdir -p ${cvs_EXPORTDIR}
    check_error $? "Error Making ${cvs_EXPORTDIR} "
        
    cd ${cvs_EXPORTDIR}

    case ${OSREV} in
		'4.8'|'4.7'|'4.6'|'4.5'|'4.4'|'4.3'|'4.2'|'4.1'|'4.0'|'3.9') 
			CVSAPP=/usr/bin/cvs
			;;
		*)	CVSAPP=/usr/bin/cvs
            if [ -x /usr/bin/opencvs ]; then
                CVSAPP=/usr/bin/opencvs
            fi
			;;
	esac

    for BRANCH in ${exportLIST}; do
        echo -n "   exporting ${BRANCH} ..."
        $CVSAPP -d$CVSROOT -q export -r $BUILDVER -d ${BRANCH} ${BRANCH} > "$LOGFILE.${BRANCH}.txt" 2> "$LOGFILE.${BRANCH}.err.txt"
        check_error $?   "ERROR: Exporting ${BRANCH}"
        echo -n "    tar ${BRANCH}"
        if [ "X${BRANCH}" == "Xports" -o "X${BRANCH}" == "Xxenocara"  ]; then
            tar -zcf ${SRCRELEASE}/${BRANCH}.tgz ${BRANCH} >> "$LOGFILE.${BRANCH}.txt" 
            check_error $? "ERROR: Archiving ${BRANCH}"
            cd ..
        else
            cd ${BRANCH}
            tar -zcf ${SRCRELEASE}/${BRANCH}.tgz . >> "$LOGFILE.${BRANCH}.txt"                         
            check_error $? "ERROR: Archiving ${BRANCH}"
            cd ${cvs_EXPORTDIR}
        fi
        echo "(done)" >> "$LOGFILE.${BRANCH}.txt" 
    done
}

bld_kernel() {
    echo ">>>Building Kernel release(8): $KERNEL"
    LOGFILE="$REP_DIR/.bld.kernel"
	if [ ! -z "$KERNEL" ]; then
		rm -rf "$cvs_BASE/src/sys/arch/${MACHINE}/compile/$KERNEL"
	fi
    cd $cvs_BASE/src/sys/arch/${MACHINE}/conf
    echo -n "    config $KERNEL"
    config $KERNEL
    check_error $?
    cd ../compile/$KERNEL
    echo -n "    a. make clean"
    make clean  > "$LOGFILE.txt" 2> "$LOGFILE.err.txt"
    check_error $?
    echo -n "    b. make depend"
    make depend  >> "$LOGFILE.txt" 2>> "$LOGFILE.err.txt" 
    check_error $?
    echo -n "    c. make"
    make >> "$LOGFILE.txt" 2>> "$LOGFILE.err.txt"
    check_error $?
    echo -n "   d. make install"
    make install >> "$LOGFILE.txt" 2>> "$LOGFILE.err.txt"
    check_error $?
    echo "(done)" >> "$LOGFILE.txt" 
    echo "(done)" >> "$LOGFILE.err.txt" 
	echo "KERNEL BUILD COMPLETE - REBOOT RECOMMENDED"
	echo ""
	echo "Verify Kernel Build [$LOGFILE.txt]"
    echo "-------------"
    tail -10 $LOGFILE.txt
    echo "-------------"
	echo "Ctrl+C and reboot, or Enter to ignore my advice (sleep 180s)"
	sleep 180
}
bld_userland(){
    echo ">>>Building USERLAND"
    LOGFILE="$REP_DIR/.bld.userland"
    echo "   rm -rf $cvs_BASE/obj/*"
	cd $cvs_BASE/obj && rm -rf .old && mkdir -p .old && sudo mv * .old &&\
    sudo rm -rf .old &
    cd $cvs_BASE/src
    echo -n "   a. make obj"
    LOGFILE="$REP_DIR/.bld.obj.userland"
    make obj > "$LOGFILE.txt" 2> "$LOGFILE.err.txt"
    check_error $?
    echo "(done)" >> "$LOGFILE.txt"
    echo "(done)" >> "$LOGFILE.err.txt"
    
    echo -n "   b. make distrib-dirs"        
    LOGFILE="$REP_DIR/.bld.distrib.userland"
    cd $cvs_BASE/src/etc && env DESTDIR=/ sudo make distrib-dirs  > "$LOGFILE.txt" 2> "$LOGFILE.err.txt"
    check_error $?
    echo "(done)" >> "$LOGFILE.txt"
    echo "(done)" >> "$LOGFILE.err.txt"
    
    cd $cvs_BASE/src
    echo -n "   c. make build (compiles and install all 'userland' utilities in the appropriate order)"
    LOGFILE="$REP_DIR/.bld.userland"
    make SUDO=sudo build  > "$LOGFILE.txt" 2> "$LOGFILE.err.txt"
    check_error $?
    echo "(done)" >> "$LOGFILE.txt"
    echo "(done)" >> "$LOGFILE.err.txt"
}

rel_base() {
    echo ">>>Building RELEASE BASE release(8): $BUILDVER "
    LOGFILE="$REP_DIR/.rel.base"
    test -d $cvs_BASE/src 
    check_error $? "Base src not available [${cvs_BASE}/src]"
	
	case ${ISOREV} in
		44|43|42|41|40|39) 
			echo "   build crunchgen"
			cd $cvs_BASE/src/distrib/crunch && make obj depend all install  > "$REP_DIR/.bld.crunchgen.txt" 2> "$REP_DIR/.bld.crunchgen.err.txt"
            check_error $?
			;;
	esac

	export DESTDIR=${DESTBASEDIR} ; export RELEASEDIR=${RELEASEBASEDIR}
    echo "   clear old release build dir [${DESTDIR}]"
	OLD=${DESTDIR}.old
	test -d ${OLD} && rm -rf ${OLD}
    test -d ${DESTDIR} && mv ${DESTDIR} ${OLD} 
	rm -rf ${OLD} &

    #~ echo "   [$RELEASEBASEDIR] clear old releasedir "
	#~ test -d ${RELEASEDIR}.old && rm -rf ${RELEASEDIR}.old
    #~ test -d ${RELEASEDIR} && mv ${RELEASEDIR} ${RELEASEDIR}.old 
	#~ rm -rf ${RELEASEDIR}.old &

    mkdir -p ${DESTDIR}
    check_error $? "ERROR: Failed makedir ${DESTDIR}"
	
	
	mkdir -p ${RELEASEDIR}
    check_error $? "ERROR: Failed makedir ${RELEASEDIR}"

    cd $cvs_BASE/src/etc
    echo -n "   a. make release @ $cvs_BASE/src/etc"
	make release > "$LOGFILE.txt" 2> "$LOGFILE.err.txt"
    check_error $?
    echo "(done)" >> "$LOGFILE.txt"
    echo "(done)" >> "$LOGFILE.err.txt"

    echo -n "   b. verify distrib/sets"
    LOGFILE="$REP_DIR/.rel.vrfy.base"
    cd $cvs_BASE/src/distrib/sets && sh checkflist > "$LOGFILE.txt" 2>&1
    check_error $?
    echo "(done)" >>   "$LOGFILE.txt"
}

bld_xenocara() {
    echo ">>>Building XENOCARA"
    LOGFILE="$REP_DIR/.bld.xenocara"
    test -d ${XSRCDIR}
    check_error $? "Xenocara src not available"

    cd ${XSRCDIR}
    echo -n "   a. rm -rf $cvs_BASE/xobj/*"
    rm -rf $cvs_BASE/xobj/*
    check_error $?
    echo -n "   b. make bootstrap"
    LOGFILE="$REP_DIR/.bld.bootstrap.xenocara"
    make bootstrap  > "$LOGFILE.txt" 2> "$LOGFILE.err.txt"
    check_error $?
    echo "(done)" >> "$LOGFILE.txt"
    echo "(done)" >> "$LOGFILE.err.txt"
    
    echo -n "   c. make obj"
    LOGFILE="$REP_DIR/.bld.obj.xenocara"
    make obj  > "$LOGFILE.txt" 2> "$LOGFILE.err.txt"
    check_error $?
    echo "(done)" >> "$LOGFILE.txt"
    echo "(done)" >> "$LOGFILE.err.txt"
    
    echo -n "   d. make build"
    LOGFILE="$REP_DIR/.bld.xenocara"
    make build  > "$LOGFILE.txt" 2> "$LOGFILE.err.txt"
    check_error $?
    echo "(done)" >> "$LOGFILE.txt"
    echo "(done)" >> "$LOGFILE.err.txt"
}

rel_xenocara() {
    cd ${XSRCDIR}
    echo ">>>Building RELEASE XENOCARA: $BUILDVER"
    LOGFILE="$REP_DIR/.rel.xenocara"
	export DESTDIR=${DESTXENDIR} ; export RELEASEDIR=${RELEASEXENDIR}	
    
    echo -n "   clear old release build dir [${DESTDIR}]"
	OLD=${DESTDIR}.old
	test -d ${OLD} && rm -rf ${OLD}
    test -d ${DESTDIR} && mv ${DESTDIR} ${OLD}
	rm -rf ${OLD} &
    
    #~ echo -n "   clear old release [${RELEASEDIR}]"
    #~ test -d ${RELEASEDIR}.old && rm -rf "${RELEASEDIR}.old"
    #~ test -d ${RELEASEDIR} && mv ${RELEASEDIR} ${RELEASEDIR}.old && \
    #~ rm -rf "${RELEASEDIR}.old" &
		
	mkdir -p ${DESTDIR}
    check_error $? "ERROR: Failed makedir ${DESTDIR}"
	
	mkdir -p ${RELEASEDIR}
    check_error $? "ERROR: Failed makedir ${RELEASEDIR}"
		
    cd ${XSRCDIR}
    echo "   a. make release"
    make release > "$LOGFILE.txt" 2> "$LOGFILE.err.txt"
    check_error $?
    echo "(done)" >> "$LOGFILE.txt"
    echo "(done)" >> "$LOGFILE.err.txt"
}
iso_layout() {
    # Ref: /usr/src/distrib/amd64/iso/Makefile
    echo ">>>AGGREGATING CD Content - Builds"
        
    rm -rf ${CDBUILD}

	mkdir -p ${CDBUILD}/${OSREV}/${MACHINE}
	mkdir -p ${CDBUILD}/${OSREV}/packages/${MACHINE}
	mkdir -p ${CDBUILD}/etc
	echo "set image /${OSREV}/${MACHINE}/bsd.rd" > ${CDBUILD}/etc/boot.conf
    DESTINATION=${CDBUILD}/${OSREV}/${MACHINE}
	
    if [ -d "$RELEASEBASEDIR" ]; then
        echo -n "   copying $RELEASEBASEDIR: " && \
        FILES="base${ISOREV}.tgz comp${ISOREV}.tgz etc${ISOREV}.tgz game${ISOREV}.tgz man${ISOREV}.tgz"
        FILES="$FILES misc${ISOREV}.tgz bsd bsd.rd bsd.mp INSTALL.${MACHINE}"
        for file in $FILES; do
            echo -n " $file" && cp -p ${RELEASEBASEDIR}/$file ${DESTINATION}
        done
        echo ""
    fi
    if [ -d "$RELEASEXENDIR" ]; then
        echo -n "   copying $RELEASEXENDIR: "
        FILES="xbase${ISOREV}.tgz xetc${ISOREV}.tgz xfont${ISOREV}.tgz xshare${ISOREV}.tgz xserv${ISOREV}.tgz"
        for file in $FILES; do
            echo -n " $file" && cp -p ${RELEASEXENDIR}/$file ${DESTINATION}
        done        
        echo ""
    fi
    echo "    cdbr" && cp -p ${RELEASEBASEDIR}/cdbr ${DESTINATION}
    echo "    cdboot" && cp -p ${RELEASEBASEDIR}/cdboot ${DESTINATION}/cdboot
    
    if [ ! -z "${SRCRELEASE}" ]; then
        echo "   Source Distributions"
        test -f ${SRCRELEASE}/ports.tgz && echo "    ports.tgz" && \
            cp -p ${SRCRELEASE}/ports.tgz ${CDBUILD}/${OSREV}/
        test -f ${SRCRELEASE}/src.tgz && echo "    src.tgz" && \
            cp -p ${SRCRELEASE}/src.tgz ${CDBUILD}/${OSREV}/
        test -f ${SRCRELEASE}/xenocara.tgz && echo "    xenocara.tgz" && \
            cp -p ${SRCRELEASE}/xenocara.tgz ${CDBUILD}/${OSREV}/
    fi        
}

iso_packages_base() {
    # Base - default install
    PKGS="bzip2 colorls curl gettext gnuwatch libdnet libiconv"
    PKGS="$PKGS libidn lua- lzo- multitail mutt nmap- pcre- pstree qdbm rsync"
    PKGS="$PKGS vim wget zsh libtool gmake"

    # Base - Benchmarking
    PKGS="$PKGS blogbench bonnie bytebench iogen lmbench netperf netpipe"
    PKGS="$PKGS netstrain pear-Benchmark randread smtp-benchmark"
    PKGS="$PKGS stress sysbench tcpblast ubench xengine"
    PKGS="$PKGS libxslt libgcrypt libgpg py-libxml"
    PKGS="$PKGS pfstat pftop tcpflow trafshow"
    iso_packages_copy        
}
iso_packages_mailserver() {
    # Mail Proxy Servers
    PKGS="postfix dovecot pflogsumm "
    PKGS="$PKGS p5-Date-Calc p5-Bit-Vector p5-Carp-Clan"
    iso_packages_copy
}
iso_packages_monitorbox() {
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
iso_packages_git() {
    PKGS="git p5-Error-"
    iso_packages_copy
}
iso_packages_optional() {
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
iso_packages_copy() {
    for package in $PKGS; do
        cp -f ${package}* "$PACKAGE_DST" >> "$REP_DIR/.iso.packages.txt" 2>> "$REP_DIR/.iso.packages.err.txt"  &&   echo -n "$package "
    done
}
iso_packages() {
    if [ ! -d "$PACKAGE_SRC" -o ! -d "$PACKAGE_DST" ]; then
        echo "ERROR: package path not found [$PACKAGE_SRC] or ${PACKAGE_DST}"
        exit 1
    fi

    echo ">>>AGGREGATING Package Collection"
    rm -f $REP_DIR/.iso.packages.txt
    rm -f $REP_DIR/.iso.packages.err.txt
    cd $PACKAGE_SRC

    #~ iso_packages_base
    #iso_packages_mailserver
    #iso_packages_monitorbox
    #iso_packages_optional
    #~ iso_packages_git
}
iso_buildimage() {
	echo ""
    echo ">>>ISO BUILD"
	#iso_mkiso
	iso_mkhybrid
}

iso_mkhybrid() {
    # Ref: /usr/src/distrib/amd64/iso/Makefile
    echo "   mkhybrid"
    
	cd ${CDBUILD}
	ISOFILE=${CDBUILD}/../openbsd${ISOREV}_${MACHINE}.${STATE}.iso
    
	mkhybrid -a -R -T -L -l -d -D -N -o ${ISOFILE} -v -v \
        -A "OpenBSD ${OSREV} ${MACHINE} Install CD" \
		-P "Copyright (c) `date +%Y` Employers Mutual Ltd" \
		-p "EML Install Media" \
		-V "OpenBSD/${MACHINE} ${OSREV} Install CD" \
        -b ${OSREV}/${MACHINE}/cdbr \
        -c ${OSREV}/${MACHINE}/boot.catalog \
		${CDBUILD} \
         > "$REP_DIR/.mkhybrid.build.txt" 2> "$REP_DIR/.mkhybrid.build.err.txt" 
    check_error $?
    echo "(done)" >> "$REP_DIR/.mkhybrid.build.txt"
    echo "(done)" >> "$REP_DIR/.mkhybrid.build.err.txt" 
    iso_tip
}
function iso_tip {

echo "
TEST Using:

    vnconfig svnd0 ${ISOFILE}
    mkdir -p $MOUNTPOINT
    mount -t cd9660 /dev/svnd0c $MOUNTPOINT
    
    ... do your tests ...
    
    umount $MOUNTPOINT
    vnconfig -u svnd0
    
    ---or----
    
    qemu -cdrom ${ISOFILE} -hda /tmp/qemu_disk.img -m 256 -boot d
        
BURN Using:

    /usr/bin/cdio -v -f /dev/rcd0c tao ${ISOFILE}"

}
cvs_getfiles() {
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
            'kernel') 
                    bld_kernel
                    ;;
            'src') 	
                    bld_userland
                    ;;
            'xenocara') 
                    bld_xenocara
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
            'src') 
                rel_base
                ;;
            'xenocara') 
                rel_xenocara
                ;;
            *) echo "Somethings broken"
                exit 1
                ;;
        esac
    done
    fi
}
iso_test() {

	ISO="$REP_DIR/openbsd${ISOREV}_${MACHINE}.${STATE}.iso"
	if [ ! -f ${ISO} ]; then
		ISO="$REP_DIR/openbsd${ISOREV}_${MACHINE}.${STATE}.mkhybrid.iso"
	fi
	if [ -f  ${ISO} -a ! -z ${MOUNTPOINT} ]; then
	
		if [ ! -d ${MOUNTPOINT} ]; then
			mkdir ${MOUNTPOINT}
		fi
		umount ${MOUNTPOINT}
		vnconfig -u svnd3 
		
		echo "Mount Point [${MOUNTPOINT}] for ISO [${ISO}]"
		vnconfig -c svnd3 ${ISO}
		mount -t cd9660 /dev/svnd3c ${MOUNTPOINT}
		echo "REMEMBER: remove mount when you are finished"
		echo "          # umount ${MOUNTPOINT}"
		echo "          # vnconfig -u svnd3"
	fi
}
iso_build() {
    if [ $oMkiso -eq 1 ]; then
        iso_layout
        iso_packages
    fi
    if [ $oMkiso -eq 1 -o $oBldiso -eq 1 ]; then
        iso_buildimage
    fi
	if [ $oTestIso -eq 1 ]; then
		iso_test
	fi
}
function check_error {
    echo " ... "
    if [ "$1" != "0" ]; then
        echo "Something Broke $*"
        exit 1
    fi
}
main() {
    get_options "$@"
        
	if [ ! -z ${CDBUILD} -a -d ${CDBUILD} ]; then
		rm -rf "${CDBUILD}"
	fi
    mkdir -p ${CDBUILD}/${OSREV}/${MACHINE}
    mkdir -p ${CDBUILD}/${OSREV}/packages/${MACHINE}
	#~ mkdir -p ${CDBUILD}/.buildinfo

    cvs_getfiles
    build_binaries
    build_release
    iso_build
}


main $@
