<?php
declare(strict_types=1);

error_reporting(E_ALL);

use PHPUnit\Framework\TestCase;
use OnePress\Db\Item;
use OnePress\Db\ItemFactory;
use Phalcon\Di\FactoryDefault;
use Phalcon\Db\Pdo\Postgresql;

class SubItem extends Item {}
class SubSubItem extends SubItem {}


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
		$item = $factory->getNew('SubItem');
		var_dump($item->getId());
		$this->assertInstanceOf('SubItem',$item);
	}
}
