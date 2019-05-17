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
					'dbname' => 'onepresstests',
					'port' => '5432',
					'username' => 'onepresstests',
					'password' => 'OnePressTests',
				]
			);
		});
	}

	public function testTableNameFromClassNameIsItems4DBItems() {
		$this->assertEquals('items',ItemFactory::getTableNameFromClassName('OnePress\\Db\\Items'));
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
		$factory->getNew('NotSubItems');
	}

	public function testNewItemIdIsNotNull() {
		$factory = new ItemFactory($this->di);
		$item = $factory->getNew('OnePress\\Db\\Items');
		$item->save();
		$this->assertNotNull($item->id);
	}

	 /**
	  * @depends testNewItemIdIsNotNull
	  * @see https://forum.phalconphp.com/discussion/8397/return-primary-key-after-createsave
	  * @see https://github.com/phalcon/cphalcon/issues/220
	  */
	 public function testGetItemById() {
		 $factory = new ItemFactory($this->di);
		 $tItem = $factory->getNew('OnePress\\Db\\Items');
		 $tItem->save();
		 $id = $tItem->id;
		 unset ($tItem);
		 $item = $factory->getById($id);
		 $this->assertInstanceOf('OnePress\\Db\\Items');
		 $this->assertEquals($id,$item->id);
	 }

	 /**
	  * @depends testNewItemIdIsNotNull
	  */
	 public function testGetSubItemById() {
		 $factory = new ItemFactory($this->di);
		 $tItem = $factory->getNew('SubItems');
		 $tItem->save();
		 $id = $tItem->id;
		 unset ($tItem);
		 $item = $factory->getById($id);
		 $this->assertInstanceOf('SubItems');
	 }
}
