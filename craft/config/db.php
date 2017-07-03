<?php

/**
 * Database Configuration
 *
 * All of your system's database configuration settings go in here.
 * You can see a list of the default settings in craft/app/etc/config/defaults/db.php
 */

return array(
	// All local settings are wildcard, to be over written by staging/live
	'*' => array(
		'server'      => 'localhost',
		'database'    => 'craft',
		'user'        => 'root',
		'password'    => 'password',
		'tablePrefix' => 'craft',
	),
);
