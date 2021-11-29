#--------------------------------------------------------------------------------------------
# Server site
#--------------------------------------------------------------------------------------------

# Set variables
DIR_PATH=${__DIR_PATH}
PUBLIC_PATH=$DIR_PATH/public_html
REVISION_NAME=$(date +"%Y%m%d%H%M%S")
REVISION_PATH=$DIR_PATH/revisions/$REVISION_NAME
SHARED_PATH=$DIR_PATH/shared

# Check exist DIR
if [ ! -D "$SHARED_PATH" ]; then
    mkdir $SHARED_PATH
fi

if [ ! -D "$DIR_PATH/revisions" ]; then
    mkdir $DIR_PATH/revisions
fi

# Make revisions directory and remove files
mkdir $REVISION_PATH
cp $DIR_PATH/deploy/deploy-build.tar.gz $REVISION_PATH
cd $REVISION_PATH
tar -xzvf deploy-build.tar.gz
rm deploy-build.tar.gz

# Check exist files
FILE=$REVISION_PATH/.htaccess
if [ -f "$FILE" ]; then
    rm -rf $FILE
fi

FILE=$REVISION_PATH/wp-config.php
if [ -f "$FILE" ]; then
    rm -rf $FILE
fi

DIR=$REVISION_PATH/wp-content/uploads
if [ -d "$DIR" ]; then
    rm -rf $DIR
fi

# Symlinks
rm -rf $PUBLIC_PATH
ln -s $REVISION_PATH $PUBLIC_PATH
ln -s $SHARED_PATH/uploads $PUBLIC_PATH/wp-content
ln -s $SHARED_PATH/.htaccess $PUBLIC_PATH/.htaccess
ln -s $SHARED_PATH/wp-config.php $PUBLIC_PATH/wp-config.php

# Unset variables and remove files
rm -rf $DIR_PATH/deploy
unset DIR_PATH
unset PUBLIC_PATH
unset REVISION_NAME
unset REVISION_PATH
unset SHARED_PATH
unset FILE
unset DIR
