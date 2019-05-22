<?php
declare(strict_types=1);

error_reporting(E_ALL);

use PHPUnit\Framework\TestCase;
use OnePress\Db\Items;
use OnePress\Db\ItemFactory;
use Phalcon\Di\FactoryDefault;
use Phalcon\Db\Adapter\Pdo\Postgresql;

class SubItems extends Items {
}
class NotSubItems{}
class SubSubItems extends SubItems {}

class ItemFactoryTest extends TestCase {
	protected $di;
	protected function setUp() {
		$this->di = new FactoryDefault();
		$this->di->set('db',new Postgresql(
				[
					'host' => 'localhost',
					'dbname' => 'onepresstests',
					'port' => '5432',
					'username' => 'onepresstests',
					'password' => 'OnePressTests',
				]
			)
		);
		$this->di->set('itemFactory', new ItemFactory($this->di));
	}

	public function testTableNameFromClassNameIsItems4DBItems() {
		$this->assertEquals('items',ItemFactory::getTableNameFromClassName('OnePress\\Db\\Items'));
	}

	public function testItemIsCreatedProperly() {
		$item = $this->di->get('itemFactory')->getNew('OnePress\\Db\\Items');
		$this->assertInstanceOf('OnePress\\Db\\Items',$item);
		$this->assertNotNull($item->uid);
	}

	public function testSubItemIsCreatedProperly() {
		$item = $this->di->get('itemFactory')->getNew('SubItems');
		$this->assertInstanceOf('SubItems',$item);
		$this->assertNotNull($item->uid);
	}

	/**
	 * @expectedException Exception
	 */
	public function testNotSubItemThrowException() {
		$this->di->get('itemFactory')->getNew('NotSubItems');
	}

	/**
	 * @expectedException \Exception
	 */
	 public function testCreateItemOutOfFactoryRaiseException() {
		 $t = new Items();
	 }

	/**
	 * @expectedException \Exception
	 */
	public function testCreateSubItemOutOfFactoryRaiseException() {
		 $t = new SubItems();
	}

	public function testGetItemById() {
		$tItem = $this->di->get('itemFactory')->getNew('OnePress\\Db\\Items');
		$uid = $tItem->uid;
		unset ($tItem);
		$item = $this->di->get('itemFactory')->getById($uid);
		$this->assertInstanceOf('OnePress\\Db\\Items');
		$this->assertEquals($id,$item->uid);
	}

	public function testGetSubItemById() {
		$tItem = $this->di->get('itemFactory')->getNew('SubItems');
		$tItem->save();
		$id = $tItem->uid;
		unset ($tItem);
		$item = $this->di->get('itemFactory')->getById($uid);
		$this->assertInstanceOf('SubItems');
	}
}
