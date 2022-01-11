#!/usr/bin/env bash
set -Eeuo pipefail


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

wpEnvs=("${!WORDPRESS_@}")
if [ ! -s wp-config.php ] && [ "${#wpEnvs[@]}" -gt 0 ]; then
    for wpConfigDocker in \
        wp-config-docker.php \
        /usr/src/wordpress/wp-config-docker.php; do
        if [ -s "$wpConfigDocker" ]; then
            echo >&2 "No 'wp-config.php' found in $PWD, but 'WORDPRESS_...' variables supplied; copying '$wpConfigDocker' (${wpEnvs[*]})"
            # using "awk" to replace all instances of "put your unique phrase here" with a properly unique string (for AUTH_KEY and friends to have safe defaults if they aren't specified with environment variables)
            awk '
					/put your unique phrase here/ {
						cmd = "head -c1m /dev/urandom | sha1sum | cut -d\\  -f1"
						cmd | getline str
						close(cmd)
						gsub("put your unique phrase here", str)
					}
					{ print }
				' "$wpConfigDocker" >wp-config.php
            if [ "$uid" = '0' ]; then
                # attempt to ensure that wp-config.php is owned by the run user
                # could be on a filesystem that doesn't allow chown (like some NFS setups)
                chown "$user:$group" wp-config.php || true
            fi
            break
        fi
    done
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
