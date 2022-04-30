
function cmp_and_cp() {
    SOURCE_FILE=$1
    TARGET_FILE=$2
    if [[ ! -d ${SOURCE_FILE} ]]
    then
        if cmp --silent -- "${SOURCE_FILE}" "${TARGET_FILE}"
        then
            echoInfo "No changes to ${SOURCE_FILE}"
        else
            echoInfo "Updating ${TARGET_FILE}"
            cp "${SOURCE_FILE}" "${TARGET_FILE}"
        fi
    else
        echoWarn "${SOURCE_FILE} not found"
    fi
}