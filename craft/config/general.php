<?php

/**
 * General Configuration
 *
 * All of your system's general configuration settings go in here.
 * You can see a list of the default settings in craft/app/etc/config/defaults/general.php
 */

// Define URL settings (port numbers are used for local development)
define('URI_SCHEME', (isset($_SERVER['HTTPS'])) ? "https://" : "http://");
define('URI_PORT', ($_SERVER['SERVER_PORT'] == '80') ? '' : ':' . $_SERVER['SERVER_PORT']);
define('SITE_URL', URI_SCHEME . $_SERVER['SERVER_NAME'] . URI_PORT . '/');

return array(
	'*' => array(
		'devMode'              => true,
		'imageDriver'          => 'imagick',
		'omitScriptNameInUrls' => true,
		'sendPoweredByHeader'  => false,
		'siteUrl'              => SITE_URL,
		'useEmailAsUsername'   => true,
	),
);
