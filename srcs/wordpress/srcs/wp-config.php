<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the
 * installation. You don't have to use the web site, you can
 * copy this file to "wp-config.php" and fill in the values.
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
define( 'DB_USER', 'wp_vlugand-' );

/** MySQL database password */
define( 'DB_PASSWORD', 'd3BAZnRfNTNydjFjMzUK' );

/** MySQL hostname */
define( 'DB_HOST', 'mysql' );

/** Database Charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8' );

/** The Database Collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

/**#@+
 * Authentication Unique Keys and Salts.
 *
 * Change these to different unique phrases!
 * You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
 * You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define('AUTH_KEY',         '5m{{~xBK-hulRT&b0dimLqwO%*Sv2FhZM[.&^>Y|bc+9{j-H-K!TJWNF8!idInq<');
define('SECURE_AUTH_KEY',  'l[n2vd0sh]aZ5i$hWY4*<9mMzh5%6*jV8:J $|;QE^UJje>`)OCU3htJ}MP<|jJ3');
define('LOGGED_IN_KEY',    '@.CO#xUc->-B0-ttujg>t9DSuOp#1Nbz MmfeGB^RUCWS8Z!4G_,g9D%Hk$Jx3j:');
define('NONCE_KEY',        ':_/g[X^c&}8M-%i-P7!1{kr_c=|w}iYkl<|1lK4J;:W-^ UA1ls#paTH1g|vY||j');
define('AUTH_SALT',        'K&=0>~+!B^WZ%piIZ2pxFGo<gX}5]5Q)i=j9C*T^</)M+u-mxWY6.Qa.ohV,w))<');
define('SECURE_AUTH_SALT', 'onz=4u|&*bsl4v#]sz+><A]EOu@|}P>[OOuCHHmUm^%<N{xUhY.(d,JWF4be<$i=');
define('LOGGED_IN_SALT',   '61wL-Aq(>6 [5=$lM9K<ysT*4z)-*XOS<)K_76szHh,<-`u*y[NRTA7^bU[_%%m)');
define('NONCE_SALT',       'S_[=a!I`|S1?EW6|+7[ {|V+v`5SRc:g09KqV_=:+[{1`.p ,Qbc`C>~ ?w+ n{X');
/**#@-*/

/**
 * WordPress Database Table prefix.
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

/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
        define( 'ABSPATH', __DIR__ . '/' );
}

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';