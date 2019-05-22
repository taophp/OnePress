<?php
declare(strict_types=1);

error_reporting(E_ALL);

use PHPUnit\Framework\TestCase;
use OnePress\Db\Items;
use OnePress\Db\ItemFactory;
use Phalcon\Di\FactoryDefault;
use Phalcon\Db\Adapter\Pdo\Postgresql;

class SubItems extends Items {
	/*protected $_settable = [
		'uid',
		'display_name',
		'test',
	];*/
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
		$this->factory = new ItemFactory($this->di);
	}

	public function testTableNameFromClassNameIsItems4DBItems() {
		$this->assertEquals('items',ItemFactory::getTableNameFromClassName('OnePress\\Db\\Items'));
	}

	public function testItemIsCreatedProperly() {
		$item = $this->factory->getNew('OnePress\\Db\\Items');
		$this->assertInstanceOf('OnePress\\Db\\Items',$item);
		$this->assertNotNull($item->uid);
	}

	public function testSubItemIsCreatedProperly() {
		$item2 = $this->factory->getNew('SubItems');
		$this->assertInstanceOf('SubItems',$item2);
		$this->assertNotNull($item2->uid);
	}
}
