#!/usr/bin/env bash
set -Eeuo pipefail

# Install mhsendmail
if [ ! -f /usr/local/bin/mhsendmail ]; then
    echo "####### start installing a mhsendmail..."

    # Install mhsendmail for Mailhog
    curl --location --output /usr/local/bin/mhsendmail https://github.com/mailhog/mhsendmail/releases/download/v0.2.0/mhsendmail_linux_amd64
    chmod +x /usr/local/bin/mhsendmail

    echo "####### install mhsendmail successful"
fi

if [ ! -f /usr/local/etc/php/conf.d/mailhog.ini ]; then
    echo "####### start config the mailhog.ini..."
    echo 'sendmail_path="/usr/local/bin/mhsendmail --smtp-addr=mailhog:1025 --from=no-reply@mailhog.local"' >/usr/local/etc/php/conf.d/mailhog.ini
    echo "####### config the mailhog.ini successful"
fi

# Install WP-CLI
if [ ! -f /usr/local/bin/wp ]; then
    echo "####### start installing a WP-CLI..."

    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    php wp-cli.phar --info
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp

    echo "####### WP-CLI successful"
fi

# Install WordPress site
if [ ! -e index.php ] && [ ! -e wp-includes/version.php ]; then

    echo "start installing WordPress..."

    wp core download --allow-root

    echo "####### install WordPress successful"

fi

# This script configures WordPress file permissions based on recommendations
# from http://codex.wordpress.org/Hardening_WordPress#File_permissions

# reset to safe defaults
find ${WP_ROOT} -exec chown ${WP_OWNER}:${WP_GROUP} {} \;
find ${WP_ROOT} -type d -exec chmod 755 {} \;
find ${WP_ROOT} -type f -exec chmod 644 {} \;

# allow wordpress to manage wp-config.php (but prevent world access)
chgrp ${WS_GROUP} ${WP_ROOT}/wp-config.php
chmod 660 ${WP_ROOT}/wp-config.php

# allow wordpress to manage .htaccess
touch ${WP_ROOT}/.htaccess
chgrp ${WS_GROUP} ${WP_ROOT}/.htaccess
chmod 664 ${WP_ROOT}/.htaccess

# allow wordpress to manage wp-content
find ${WP_ROOT}/wp-content -exec chgrp ${WS_GROUP} {} \;
find ${WP_ROOT}/wp-content -type d -exec chmod 775 {} \;
find ${WP_ROOT}/wp-content -type f -exec chmod 664 {} \;

# execute
exec "$@"
