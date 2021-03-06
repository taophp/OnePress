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

	public function testGetItemByUid() {
		$factory = $this->di->get('itemFactory');
		$tItem = $factory->getNew('OnePress\\Db\\Items');
		$uid = $tItem->uid;
		unset ($tItem);
		$item = $factory->getByUid($uid);
		$this->assertInstanceOf('OnePress\\Db\\Items',$item);
		$this->assertEquals($uid,$item->uid);
	}

	public function testGetSubItemByUid() {
		$factory = $this->di->get('itemFactory');
		$tItem = $factory->getNew('SubItems');
		$uid = $tItem->uid;
		unset ($tItem);
		$item = $factory->getByUid($uid);
		$this->assertInstanceOf('SubItems',$item);
		$this->assertEquals($uid,$item->uid);
	}

	/**
	 * @expectedException Exception
	 */
	public function testItemsFindFirstThrowException() {
		$tItem = $this->di->get('itemFactory')->getNew('SubItems');
		$name = $tItem->display_name;
		$uid = $tItem->uid;
		unset($tItem);
		$item = SubItems::findFirst(["display_name = '".$name."'"]);
	}


	public function testFind() {
		$factory = $this->di->get('itemFactory');
		$tItem = $factory->getNew('SubItems');
		$name = $tItem->display_name;
		$uid = $tItem->uid;
		unset($tItem);
		$item = $factory->findFirst(["display_name = '".$name."'"]);
		$this->assertInstanceOf('SubItems',$item);
		$this->assertEquals($uid,$item->uid);
		$this->assertEquals($name,$item->display_name);
	}

	/**
	 * @expectedException Exception
	 */
	public function testSubItemsFindFirst_display_nameThrowException() {
		$tItem = $this->di->get('itemFactory')->getNew('SubItems');
		$name = $tItem->display_name;
		unset($tItem);
		$item = SubItems::findFirstByDisplay_name($name);
	}

	public function testItemFactoryFindFirst_display_name() {
		$factory = $this->di->get('itemFactory');
		$tItem = $factory->getNew('SubItems');
		$name = $tItem->display_name;
		$uid = $tItem->uid;
		unset($tItem);
		$item = $factory->findFirst(["display_name = '$name'"]);
		$this->assertInstanceOf('SubItems',$item);
	}
}
