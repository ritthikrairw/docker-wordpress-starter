<?php

/**

 * The base configuration for WordPress

 *

 * The wp-config.php creation script uses this file during the installation.

 * You don't have to use the web site, you can copy this file to "wp-config.php"

 * and fill in the values.

 *

 * This file contains the following configurations:

 *

 * * MySQL settings

 * * Secret keys

 * * Database table prefix

 * * ABSPATH

 *

 * @link https://wordpress.org/support/article/editing-wp-config-php/

 *

 * @package WordPress

 */


// ** MySQL settings - You can get this info from your web host ** //

/** The name of the database for WordPress */

define( 'DB_NAME', 'wordpress' );


/** MySQL database username */

define( 'DB_USER', 'wordpress' );


/** MySQL database password */

define( 'DB_PASSWORD', '123456' );


/** MySQL hostname */

define( 'DB_HOST', 'mariadb:3306' );


/** Database charset to use in creating database tables. */

define( 'DB_CHARSET', 'utf8' );


/** The database collate type. Don't change this if in doubt. */

define( 'DB_COLLATE', '' );


/**#@+

 * Authentication unique keys and salts.

 *

 * Change these to different unique phrases! You can generate these using

 * the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}.

 *

 * You can change these at any point in time to invalidate all existing cookies.

 * This will force all users to have to log in again.

 *

 * @since 2.6.0

 */

define( 'AUTH_KEY',         '5kDAhae<N);6!!V`wi=/<KzP/AqEk$ig|;WJ>I5/B%pW5<aaY5XsxCeN:s(w>bhz' );

define( 'SECURE_AUTH_KEY',  'XH$SSV}_q)itM251rJLzlUhFYp.o HBWIBU;<&46<k@9KFV~xEAhT;pR@Z,.lBhP' );

define( 'LOGGED_IN_KEY',    '!J6|Ah~!vu;@:kkh5*Hpd>ohyq_E-e{VD#M:|i@i{ki$Q6 [H$M~z+[j.1rs2kut' );

define( 'NONCE_KEY',        '(>`>68g#d/q[]6y}e )heHGBD {&}TXLY=W%, TdggO<0kwDq6c1FF/|N#rbgkGA' );

define( 'AUTH_SALT',        '+i#wk6xvzcS +s<|MxsWVzAPJdchygtam3S Vwp+_EVg{ZE0[CA)q[Pev<vVcQ`E' );

define( 'SECURE_AUTH_SALT', '4J@h:]c&Lxn |:xl1fOk)FB*DVClxXCznX4ds-%+Z@4ITYFaAn>`KFWnPR(,QDx5' );

define( 'LOGGED_IN_SALT',   'K9f/mRY&]Vhy$9)g}lx3CmPt#B^{< UU|pgQ}KmxvHgmRqq-bzHSJp$7=5JueD0q' );

define( 'NONCE_SALT',       '.E9ZCXYw}3CCpW#( FyaSc{2Q..Iert&5}Wl=Xm1&|H2XcL0sH,Ee4RTPlKgTp2Y' );


/**#@-*/


/**

 * WordPress database table prefix.

 *

 * You can have multiple installations in one database if you give each

 * a unique prefix. Only numbers, letters, and underscores please!

 */

$table_prefix = 'wp_';


/**

 * For developers: WordPress debugging mode.

 *

 * Change this to true to enable the display of notices during development.

 * It is strongly recommended that plugin and theme developers use WP_DEBUG

 * in their development environments.

 *

 * For information on other constants that can be used for debugging,

 * visit the documentation.

 *

 * @link https://wordpress.org/support/article/debugging-in-wordpress/

 */

define( 'WP_DEBUG', false );


/* Add any custom values between this line and the "stop editing" line. */




define( 'FS_METHOD', 'direct' );
/**
 * The WP_SITEURL and WP_HOME options are configured to access from any hostname or IP address.
 * If you want to access only from an specific domain, you can modify them. For example:
 *  define('WP_HOME','http://example.com');
 *  define('WP_SITEURL','http://example.com');
 *
 */
if ( defined( 'WP_CLI' ) ) {
	$_SERVER['HTTP_HOST'] = '127.0.0.1';
}

define( 'WP_HOME', 'http://' . $_SERVER['HTTP_HOST'] . '/' );
define( 'WP_SITEURL', 'http://' . $_SERVER['HTTP_HOST'] . '/' );
define( 'WP_AUTO_UPDATE_CORE', false );
/* That's all, stop editing! Happy publishing. */


/** Absolute path to the WordPress directory. */

if ( ! defined( 'ABSPATH' ) ) {

	define( 'ABSPATH', __DIR__ . '/' );

}


/** Sets up WordPress vars and included files. */

require_once ABSPATH . 'wp-settings.php';

/**
 * Disable pingback.ping xmlrpc method to prevent WordPress from participating in DDoS attacks
 * More info at: https://docs.bitnami.com/general/apps/wordpress/troubleshooting/xmlrpc-and-pingback/
 */
if ( !defined( 'WP_CLI' ) ) {
	// remove x-pingback HTTP header
	add_filter("wp_headers", function($headers) {
		unset($headers["X-Pingback"]);
		return $headers;
	});
	// disable pingbacks
	add_filter( "xmlrpc_methods", function( $methods ) {
		unset( $methods["pingback.ping"] );
		return $methods;
	});
}
