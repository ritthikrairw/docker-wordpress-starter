#!/usr/bin/env bash

#--------------------------------------------------------------------------------------------
# Server site
#--------------------------------------------------------------------------------------------

# Set variables
DIR_PATH=$__DIR_PATH
PUBLIC_PATH=$DIR_PATH/public_html
REVISION_NAME=$(date +"%Y%m%d%H%M%S")
REVISION_PATH=$DIR_PATH/revisions/$REVISION_NAME
SHARED_PATH=$DIR_PATH/shared

# Check exist DIR
[ ! -d "$SHARED_PATH" ] && sudo mkdir $SHARED_PATH
[ ! -d "$DIR_PATH/revisions" ] && sudo mkdir $DIR_PATH/revisions

# Make revisions directory and remove files
sudo mkdir $REVISION_PATH
sudo cp $DIR_PATH/deploy/deploy-build.tar.gz $REVISION_PATH
cd $REVISION_PATH
sudo tar -xzvf deploy-build.tar.gz
sudo rm deploy-build.tar.gz

# Check exist files
FILE=$REVISION_PATH/.htaccess
if [ -f "$FILE" ]; then
    sudo rm -rf $FILE
fi

FILE=$REVISION_PATH/wp-config.php
if [ -f "$FILE" ]; then
    sudo rm -rf $FILE
fi

DIR=$REVISION_PATH/wp-content/uploads
if [ -d "$DIR" ]; then
    sudo rm -rf $DIR
fi

# Symlinks
sudo rm -rf $PUBLIC_PATH
sudo ln -s $REVISION_PATH $PUBLIC_PATH
sudo ln -s $SHARED_PATH/uploads $PUBLIC_PATH/wp-content
sudo ln -s $SHARED_PATH/.htaccess $PUBLIC_PATH/.htaccess
sudo ln -s $SHARED_PATH/wp-config.php $PUBLIC_PATH/wp-config.php

# Set chown and chmod
USER=$__USER
GROUP=$__GROUP

# Reset to safe defaults
find $PUBLIC_PATH -exec chown $USER:$GROUP {} \;
find $PUBLIC_PATH -type d -exec chmod 755 {} \;
find $PUBLIC_PATH -type f -exec chmod 644 {} \;

# allow wordpress to manage wp-config.php (but prevent world access)
chgrp ${GROUP} $PUBLIC_PATH/wp-config.php
chmod 660 $PUBLIC_PATH/wp-config.php

# allow wordpress to manage .htaccess
touch $PUBLIC_PATH/.htaccess
chgrp $GROUP $PUBLIC_PATH/.htaccess
chmod 664 $PUBLIC_PATH/.htaccess

# allow wordpress to manage wp-content
find $PUBLIC_PATH/wp-content -exec chgrp $GROUP {} \;
find $PUBLIC_PATH/wp-content -type d -exec chmod 775 {} \;
find $PUBLIC_PATH/wp-content -type f -exec chmod 664 {} \;

# Unset variables and remove files
sudo rm -rf $DIR_PATH/deploy
unset DIR_PATH
unset PUBLIC_PATH
unset REVISION_NAME
unset REVISION_PATH
unset SHARED_PATH
unset FILE
unset DIR
