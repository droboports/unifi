### UNIFI ###
_build_unifi() {
local VERSION="4.7.5"
local FOLDER="UniFi"
local FILE="${FOLDER}.unix.zip"
local URL="http://www.ubnt.com/downloads/unifi/${VERSION}/${FILE}"

_download_file_in_folder "${FILE}" "${URL}" "${VERSION}"
mkdir -p "target"
if [ -d "target/${FOLDER}" ]; then rm -vfr "target/${FOLDER}"; fi
unzip "download/${VERSION}/${FILE}" -d "${PWD}/target"
mkdir -p "${DEST}/data"
cp -vafr "target/${FOLDER}/"* "${DEST}/"
}

### MONGODB ###
_build_mongodb() {
local VERSION="3.0.2"
local FOLDER="mongodb3"
local FILE="mongod"
local URL="https://github.com/droboports/${FOLDER}/releases/download/v${VERSION}/${FILE}"

_download_file_in_folder "${FILE}" "${URL}" "${DROBO}"
if [ ! -d "${DEST}/bin" ]; then mkdir -p "${DEST}/bin"; fi
if [   -h "${DEST}/bin/${FILE}" ]; then rm -vf "${DEST}/bin/${FILE}"; fi
cp -vaf "download/${DROBO}/${FILE}" "${DEST}/bin/"
chmod a+x "${DEST}/bin/${FILE}"
}

_build() {
  _build_unifi
  _build_mongodb
  _package
}
