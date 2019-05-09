<?php
declare(strict_types=1);

error_reporting(E_ALL);

use PHPUnit\Framework\TestCase;
use OnePress\Db\Items;
use OnePress\Db\ItemFactory;
use Phalcon\Di\FactoryDefault;
use Phalcon\Db\Adapter\Pdo\Postgresql;

class SubItems extends Items {}
class NotSubItems{}
class SubSubItems extends SubItems {}


class ItemFactoryTest extends TestCase {
	protected $di;
	protected function setUp() {
		$this->di = new FactoryDefault();
		$this->di->set('db',function() {
			return new Postgresql(
				[
					'host' => 'localhost',
					'dbname' => 'OnePressTests',
					'port' => '5432',
					'username' => 'OnePressTests',
					'password' => 'OnePressTests',
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
	 * @expectedException \Exception
	 */
	public function testNotSubItemThrowException() {
		$factory = new ItemFactory($this->di);
		try {
			$factory->getNew('NotSubItems');
		} catch (\Exception $e) {
			print_r($e);
		}

	}

}
