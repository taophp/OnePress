<?php
declare(strict_types=1);

error_reporting(E_ALL);

use PHPUnit\Framework\TestCase;
use OnePress\Db\Items;
use OnePress\Db\ItemFactory;
use Phalcon\Di\FactoryDefault;
use Phalcon\Db\Adapter\Pdo\Postgresql;

class SubItems extends Items {}
class SubSubItems extends SubItems {}


class ItemFactoryTest extends TestCase {
	protected $di;
	protected function setUp() {
		$this->di = new FactoryDefault();
		$this->di->set('db',function() {
			return new Postgresql(
				[
					'host' => 'localhost',
					'dbname' => 'testonepress',
					'port' => '5432',
					'username' => 'test',
					'password' => 'test',
				]
			);
		});
	}

	public function testSubItemIsCreated() {
		$factory = new ItemFactory($this->di);
		$item = $factory->getNew('SubItems');
		$this->assertInstanceOf('SubItems',$item);
	}

	/**
	 * @expectedException Exception
	 */
	public function testNotSubItemThrowException() {
		$factory = new ItemFactory($this->di);
		$factory->getNew('NotSubItems');

	}

}
