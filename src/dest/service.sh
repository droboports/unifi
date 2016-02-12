#!/usr/bin/env sh
#
# UniFi AP Controller service

# import DroboApps framework functions
. /etc/service.subr

framework_version="2.1"
name="unifi"
version="4.9.1-691f5a97"
description="UniFi AP Controller"
depends="java8"
webui=":8043/"

prog_dir="$(dirname "$(realpath "${0}")")"
tmp_dir="/tmp/DroboApps/${name}"
pidfile="${tmp_dir}/pid.txt"
logfile="${tmp_dir}/log.txt"
statusfile="${tmp_dir}/status.txt"
errorfile="${tmp_dir}/error.txt"
daemon="${DROBOAPPS_DIR}/java8/bin/java"

# backwards compatibility
if [ -z "${FRAMEWORK_VERSION:-}" ]; then
  framework_version="2.0"
  . "${prog_dir}/libexec/service.subr"
fi

start() {
  export LANG="C"
  export LC_ALL="C"
  cd "${prog_dir}"
  setsid "${daemon}" -jar "${prog_dir}/lib/ace.jar" start &
  local _pid=$!
  if [ ${_pid} -gt 0 ]; then
    echo "${_pid}" > "${pidfile}"
  fi
}

stop() {
  export LANG="C"
  export LC_ALL="C"
  "${daemon}" -jar "${prog_dir}/lib/ace.jar" stop
}

force_stop() {
  export LANG="C"
  export LC_ALL="C"
  start-stop-daemon -K -s 9 -p "${pidfile}" -x "${daemon}" -q
  "${prog_dir}/bin/mongod" --data "${prog_dir}/data/db" --shutdown
}

# boilerplate
if [ ! -d "${tmp_dir}" ]; then mkdir -p "${tmp_dir}"; fi
exec 3>&1 4>&2 1>> "${logfile}" 2>&1
STDOUT=">&3"
STDERR=">&4"
echo "$(date +"%Y-%m-%d %H-%M-%S"):" "${0}" "${@}"
set -o errexit  # exit on uncaught error code
set -o nounset  # exit on unset variable
set -o xtrace   # enable script tracing

main "${@}"
