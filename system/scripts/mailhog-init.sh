#!/bin/sh

echo "mhsendmail installing..."

# Install mhsendmail for Mailhog
curl --location --output /usr/local/bin/mhsendmail https://github.com/mailhog/mhsendmail/releases/download/v0.2.0/mhsendmail_linux_amd64
chmod +x /usr/local/bin/mhsendmail

echo "config the mailhog..."
echo 'sendmail_path="/usr/local/bin/mhsendmail --smtp-addr=mailhog:1025 --from=no-reply@mailhog.local"' > /usr/local/etc/php/conf.d/mailhog.ini

echo "done."

# execute
exec "php-fpm"