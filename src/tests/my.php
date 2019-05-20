<?php
declare(strict_types=1);

error_reporting(E_ALL);

use PHPUnit\Framework\TestCase;
use OnePress\Db\Items;
use OnePress\Db\ItemFactory;
use Phalcon\Di\FactoryDefault;
use Phalcon\Db\Adapter\Pdo\Postgresql;

class SubItems extends Items {
	protected $_settable = [
		'uid',
		'display_name',
		'test',
	];
}
class NotSubItems{}
class SubSubItems extends SubItems {}

$di = new FactoryDefault();
$di->set('db',new Postgresql(
		[
			'host' => 'localhost',
			'dbname' => 'onepresstests',
			'port' => '5432',
			'username' => 'onepresstests',
			'password' => 'OnePressTests',
		]
	));
$factory = new ItemFactory($di);

$item = $factory->getNew('OnePress\\Db\\Items');
var_dump(__LINE__);

$subItem = $factory->getNew('SubItems');
var_dump(__LINE__);
