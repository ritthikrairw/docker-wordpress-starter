#!/bin/bash


#--------------------------------------------------------------------------------------------
# Jenkins build script
#--------------------------------------------------------------------------------------------

# Remove all *.gz files

echo "start remove old package..."

rm -rf ${WORKSPACE}/*.gz
rm -rf ${WORKSPACE}/system/*.gz

echo "remove old package success."

echo "current workspace directory"
echo ${WORKSPACE}

echo "start build package"

# Build Website Package
FILE_NAME=deploy-build.tar.gz \
    ;
tar -zcf \
    $FILE_NAME \
    --exclude="*.git*" \
    --exclude="*.htaccess*" \
    --exclude="./wp-config**" \
    --exclude="./wp-content/uploads" \
    -C ${WORKSPACE}/app/public . \
    ;
unset FILE_NAME \
    ;