#!/bin/sh

### BEGIN INIT INFO
# Provides:          ncuxywka
# Required-Start:    $local_fs $remote_fs $network $syslog
# Required-Stop:     $local_fs $remote_fs $network $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: starts the ncuxywka.com backend
# Description:       starts the ncuxywka.com backend 
### END INIT INFO



# Source function library.
. /lib/lsb/init-functions
. /lib/init/vars.sh

PROJECT_NAME="ncuxywka"
STARMAN="/usr/bin/starman"
PIDFILE="/var/run/starman/$PROJECT_NAME.pid"
APP_PATH="/home/web/ncuxywka.com"
APP="$APP_PATH/bin/app.psgi"
CONFIG="$APP_PATH/conf"
ARGS="\
	--pid $PIDFILE \
	--user www-data \
	--workers 2 \
	-I$CONFIG \
	--error-log /var/log/starman/$PROJECT_NAME.error.log \
	--access-log /var/log/starman/$PROJECT_NAME.access.log \
	--port 3000 -D "

WORKERS=2
MAX_REQUESTS=1000
LISTEN=":3000"
USER="www-data"
RUN_ENV="/usr/bin/env perl -I$CONFIG"
#[ -f /etc/sysconfig/starman ] && . /etc/sysconfig/starman

if [ -z "$APP" ]; then
    echo "Can't proceed, \$APP not defined"
    exit 1
fi

running() {
    if [ ! -r ${PIDFILE} ]; then
        return 1
    fi
    kill -0 `cat ${PIDFILE}`
    return $?
}

start() {
    if running; then
        PID=`cat ${PIDFILE}`
        echo "$PROJECT_NAME already running (pid $PID from ${PIDFILE}), can't start"
        exit 1
    fi

	echo -n "Starting $PROJECT_NAME: "
	#su -s /bin/sh $USER -c "$STARMAN $ARGS $APP"
	$STARMAN $ARGS $APP
	RETVAL=$?

    echo
    [ $RETVAL = 0 ]
    return $RETVAL
}

apptest() {
    echo -n "Checking $PROJECT_NAME startup: "
    su -s /bin/bash $USER -c "$RUN_ENV $APP"
    if [ "$?" != "0" ] ; then
        echo "Application test failed"
		exit $?
    fi
    echo "OK"
}

restart() {
    if ! running; then
        echo "$PROJECT_NAME not running, can't restart"
        exit 1
    fi
    echo -n "Restarting $PROJECT_NAME: "
    apptest
    stop
    start
}

stop() {
    if ! running; then
        echo "$PROJECT_NAME not running, can't stop"
        exit 1
    fi
    echo -n "Stopping $PROJECT_NAME: "
    kill -s QUIT `cat ${PIDFILE}`
    RETVAL=$?
    echo
     [ $RETVAL = 0 ] && rm -f ${PIDFILE}
     [ $RETVAL = 0 ] && echo "OK"
}

case "$1" in
  start)
    start
    ;;
  restart)
    restart
    ;;
  stop)
    stop
    ;;
  apptest)
   ;;
  *)

  echo "Usage: $PROJECT_NAME {start|restart|stop|apptest}"
  exit 1
esac

exit $RETVAL

