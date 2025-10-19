# ------------------------------------------------------
# File Utils Library - Common file functions for scripts
# ------------------------------------------------------

# Compare and copy file if different
# Usage: cmpcp <source_file> <target_file>
# Copies source to target only if files differ or target doesn't exist
function cmpcp() {
    SOURCE_FILE=$1
    TARGET_FILE=$2
    if [[ ! -d ${SOURCE_FILE} ]]
    then
        if cmp --silent -- "${SOURCE_FILE}" "${TARGET_FILE}"
        then
            echo "No changes to ${SOURCE_FILE}"
        else
            echo "Updating ${TARGET_FILE}"
            cp "${SOURCE_FILE}" "${TARGET_FILE}"
        fi
    else
        echo "${SOURCE_FILE} not found"
    fi
}
