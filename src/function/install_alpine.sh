INSTALL_ALPINE () {
    
    ARCH=$(uname -m)
    URL=https://dl-cdn.alpinelinux.org
    MIRROR_URL=$URL/MIRRORS.txt
    MIRRORS=$(curl -s $MIRROR_URL --connect-timeout 10)
    REL=edge
    REL_URL=$URL/$REL/releases/$ARCH/latest-releases.yaml
    
    [ -d $DIR ] || mkdir $DIR
    
    [ -d $ROOT ] || mkdir $ROOT
    
    [ -d $TMP ] || mkdir $TMP
    
    UMOUNT
    
    rm -rf $ROOT/*
    
    LATEST_RELEASES="$(curl -fs $REL_URL --connect-timeout 10)"
    if [ "$LATEST_RELEASES" = "" ]; then
        printf "install error: internet connection.\n"
        exit
    fi
    echo "$LATEST_RELEASES" > $DIR/alpine-$REL-releases.yaml
    REL_VER=$(cat $DIR/alpine-$REL-releases.yaml | grep -m 1 -o version.* | sed -e 's/version\:\s//g')
    ROOTFS="alpine-minirootfs-${REL_VER}-${ARCH}.tar.gz"
    URL_ROOTFS=$URL/$REL/releases/$ARCH/$ROOTFS
    ROOTFS_FILE=$DIR/$ROOTFS
    
    if [ ! -f $DIR/$ROOTFS ]; then
        curl --progress-bar -L --fail --retry 4 $URL_ROOTFS -o $ROOTFS_FILE || {
            printf "install: error: failed to download file.\n"
            printf "installation aborted.\n"
            exit 1
        }
    fi
    if [ ! -f $DIR/$ROOTFS.sha256 ]; then
        curl --progress-bar -L --fail --retry 4 $URL_ROOTFS.sha256 -o $ROOTFS_FILE.sha256 || {
            printf "install: error: failed to download file.\n"
            exit 1
        }
    fi
    OLD_PWD=$PWD
    cd $DIR
    sha256sum --check --status ${ROOTFS}.sha256 || {
        rm -rf $ROOTFS_FILE
        rm -rf $ROOTFS_FILE.sha256
        printf "install error: downloaded file corrupted.\n"
        printf "installation aborted.\n"
        exit 1
    }
    cd $OLD_PWD
    tar -xf $ROOTFS_FILE -C $ROOT || {
        printf "install error: $ROOTFS corrupted."
        rm -rf $ROOTFS_FILE
        rm -rf $ROOTFS_FILE.sha256
        printf "installation aborted.\n"
        exit 1
    }
    cp $ROOT/etc/apk/repositories $ROOT/etc/apk/repositories.bak
    printf "https://dl-cdn.alpinelinux.org/alpine/$REL/main/\n" > $ROOT/etc/apk/repositories
    printf "https://dl-cdn.alpinelinux.org/alpine/$REL/community/\n" >> $ROOT/etc/apk/repositories
    printf "https://dl-cdn.alpinelinux.org/alpine/edge/testing/\n" >> $ROOT/etc/apk/repositories
    printf "nameserver 1.1.1.1" > $ROOT/etc/resolv.conf
    printf "alpine" > $ROOT/etc/hostname
    echo "PS1='\W \\$ ' " >> $ROOT/etc/profile
    echo 'cd $HOME' >> $ROOT/etc/profile
    #EXEC "apk update"
    #EXEC "apk upgrade"
    printf "$PROGRAM: Alpine installed.\n"
    return 1
}
