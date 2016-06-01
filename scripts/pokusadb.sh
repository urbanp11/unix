#!/bin/bash

function _error_exit() {
    echo "$1" 1>&2
    exit 1
}

#
# main
#

if [ -z "$(adb devices | grep -v "List of devices attached" | egrep '\S+')" ]; then
    _error_exit "no devices"
elif [ $(adb devices | grep -v "List of devices attached" | egrep '\S+' | wc -l | awk '{print $1}') -eq 1 ]; then
    _ADB_DEVICE=$(adb devices | grep -v "List of devices attached" | egrep '\S+' | awk '{print $1}')
else
    _ADB_DEVICE=$(adb devices | grep -v "List of devices attached" | egrep '\S+' | peco | awk '{print $1}')
fi

_ADB="adb -s $_ADB_DEVICE"
_DEVICE_NAME=$(adb shell getprop ro.product.model | perl -p -ne 's|\s+||g')
DATE=`date '+%Y-%m-%d'`
TIME=`date '+%H_%M_%S'`
FILEDIR="$HOME/var/log/logcat/$DATE"
FILE=${FILEDIR}/${_DEVICE_NAME}-${_ADB_DEVICE}-${TIME}.log
OPTION_COLOR=0

# option parse
for OPT in "$@"
do
    case "$OPT" in
        -c|--color)
            OPTION_COLOR=1
            shift 1
            ;;
        *)
            if [[ ! -z "$1" ]] && [[ ! "$1" =~ ^-+ ]]; then
                args+=( "$1" )
                shift
            fi
            ;;
    esac
done

COMMAND=${args[0]}
PARAMS=${args[@]:1}

if [ "$COMMAND" == "help" ]; then
    cat << __USAGE__
lctee <command> (<argument>)
    file:
        show todays filelist.
    error <filepath>:
        show grep error
    last:
        show last log.
__USAGE__
    exit 0
fi

if [ "$COMMAND" = "file" ]; then
    find $FILEDIR -type f
    exit 0
elif [ "$COMMAND" = "clear" ]; then
    $_ADB logcat -c
    exit 0
elif [ "$COMMAND" = "error" ]; then
    FILE=$PARAMS[0]

    if [ "$FILE" = "" ]; then
        FILE=$($0 file | tail -1)
    fi

    cat $FILE | cut -c34- | sed 's/^[^:]*: //g' | egrep -C 5 '^\tat'
    ERROR_COUNT=`cat $FILE | cut -c34- | sed 's/^[^:]*: //g' | egrep -C 5 '^\tat' | uniq -c | grep '2 --' | wc -l`
    echo "EXCEPITONS: $ERROR_COUNT"
    exit 0
elif [ "$COMMAND" == "last" ]; then
    FILE=$($0 file | tail -1)
    if [ $OPTION_COLOR -eq 1 ]; then
        cat $FILE | perl -F'\s+' -lane 'use feature ":5.10"; $line=$_; given($F[4]) {when("V"){say "\e[37m$line\e[0m"}when("D"){say "\e[39m$line\e[0m"}when("I"){say "\e[32m$line\e[0m"}when("W"){say "\e[33m$line\e[0m"}when("E"){say "\e[31m$line\e[0m"}default{say "$line"}}'
    else
        cat $FILE
    fi

    exit 0
fi

mkdir -p $FILEDIR
if [ $OPTION_COLOR -eq 1 ]; then
    $_ADB logcat -v threadtime | tee $FILE | perl -F'\s+' -lane 'use feature ":5.10"; $line=$_; given($F[4]) {when("V"){say "\e[37m$line\e[0m"}when("D"){say "\e[39m$line\e[0m"}when("I"){say "\e[32m$line\e[0m"}when("W"){say "\e[33m$line\e[0m"}when("E"){say "\e[31m$line\e[0m"}default{say "$line"}}'
else
    $_ADB logcat -v threadtime | tee $FILE
fi