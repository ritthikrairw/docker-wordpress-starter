#--------------------------------------------------------------------------------------------
# Jenkins build script
#--------------------------------------------------------------------------------------------

# Remove all *.gz files
rm -rf *.gz

# Build Website Package
FILE_NAME=deploy-build.tar.gz \
    ;
tar -zcvf \
    $FILE_NAME \
    --exclude="*.git*" \
    --exclude="*.htaccess*" \
    --exclude="./wp-config**" \
    --exclude="./wp-content/uploads" \
    -C app/public . \
    ;
unset FILE_NAME \
    ;