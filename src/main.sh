if [ ! -z $1 ]; then
    case $1 in
        -*)
            unset $EXEC
            unset $COMMAND
        ;;
        *)
            EXEC=1
            COMMAND=$@
        ;;
    esac
fi

if [ -z $EXEC ]; then
    OPT=$(getopt -n $PROGRAM -o 'hvil' -l help,version,install,login -- "$@")
    if [ $? -ne 0 ]; then
        printf "Try '$PROGRAM --help' for more information.\n"
        exit
    fi
    eval set -- $OPT
    while true; do
        if [ "$1" = "--" ]; then
            shift
            PARAM=$@
            break
        else
            case $1 in
                -h|--help)
                    _HELP=1
                ;;
                -v|--version)
                    _VERSION=1
                ;;
                -i|--install)
                    _INSTALL=1
                ;;
                -l|--login)
                    _LOGIN=1
                ;;
                *)
                    break
                ;;
            esac
        fi
        shift
    done
fi

if [ ! -z $EXEC ]; then
    if [ ! -f $ROOT/etc/os-release ]; then
        printf "$(basename $0): is not installed.\n"
        printf "Try '$(basename $0) --install' to install.\n"
        exit 1
    fi
    EXEC $COMMAND
else
    if [ ! -z $_HELP ]; then
        HELP
        elif [ ! -z $_VERSION ]; then
        VERSION
        elif [ ! -z $_INSTALL ]; then
        INSTALL $PARAM
        elif [ ! -z $_LOGIN ]; then
        LOGIN
    else
        if [ -f $ROOT/etc/os-release ]; then
            . $ROOT/etc/os-release
            printf "$(basename $0): ($ID) is ready.\n"
        else
            printf "$(basename $0): is not installed.\n"
        fi
        
        printf "Try '$(basename $0) --help' for more information.\n"
        
        exit 1
    fi
fi