INSTALL_UBUNTU () {
    
    URL=https://cdimage.ubuntu.com
    REL=noble
    REL_VER=24.04.1
    REL_URL=$URL/ubuntu-base/releases/$REL/release

    #REL_URL=$URL/ubuntu-base/$REL/daily/current
    
    if [ "$ARCH" = "x86_64" ]; then
        REL_ARCH=amd64
    fi

    ROOTFS=ubuntu-base-$REL_VER-base-$REL_ARCH.tar.gz
    #ROOTFS=$REL-base-$REL_ARCH.tar.gz
    URL_ROOTFS=$REL_URL/$ROOTFS
    ROOTFS_FILE=$DIR/$ROOTFS
    
    [ -d $DIR ] || mkdir $DIR
    
    [ -d $ROOT ] || mkdir $ROOT
    
    [ -d $TMP ] || mkdir $TMP
    
    UMOUNT
    
    rm -rf $ROOT/*
    
    if [ ! -f $DIR/$ROOTFS ]; then
        curl --progress-bar -L --fail --retry 4 $URL_ROOTFS -o $ROOTFS_FILE || {
            printf "install: error: failed to download file.\n"
            printf "installation aborted.\n"
            exit 1
        }
    fi
    
    tar -xf $ROOTFS_FILE -C $ROOT || {
        printf "install error: $ROOTFS corrupted."
        rm -rf $ROOTFS_FILE
        rm -rf $ROOTFS_FILE.sha256
        printf "installation aborted.\n"
        exit 1
    }
    
    printf "nameserver 1.1.1.1" > $ROOT/etc/resolv.conf
	printf "ubuntu" > $ROOT/etc/hostname
	echo "PS1='\W \\$ ' " >> $ROOT/root/.bashrc
	echo 'cd $HOME' >> $ROOT/etc/bash.bashrc
    printf "$(basename $0): Ubuntu installed.\n"
    return 1
}