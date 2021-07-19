#!/bin/sh

echo "checking the mhsendmail existing..."
if [ ! -f /usr/local/bin/mhsendmail ]; then
    echo "mhsendmail does not exist"
    echo "start installing a mhsendmail..."

    # Install mhsendmail for Mailhog
    curl --location --output /usr/local/bin/mhsendmail https://github.com/mailhog/mhsendmail/releases/download/v0.2.0/mhsendmail_linux_amd64
    chmod +x /usr/local/bin/mhsendmail

    echo "install mhsendmail successful"

else
    echo "mhsendmail is existed"
fi

echo "checking the mailhog.ini..."
if [ ! -f /usr/local/etc/php/conf.d/mailhog.ini ]; then
    echo "start config the mailhog.ini..."
    echo 'sendmail_path="/usr/local/bin/mhsendmail --smtp-addr=mailhog:1025 --from=no-reply@mailhog.local"' > /usr/local/etc/php/conf.d/mailhog.ini
    echo "config the mailhog.ini successful"
else
    echo "mailhog.ini already configured"
fi

# execute
exec "php-fpm"