<?php
declare(strict_types=1);

error_reporting(E_ALL);

use PHPUnit\Framework\TestCase;
use OnePress\Db\Item;
use OnePress\Db\ItemFactory;
use Phalcon\Di\FactoryDefault;
use Phalcon\Db\Pdo\Sqlite;

class SubItem extends Item {}
class SubSubItem extends SubItem {}


class ItemFactoryTest extends TestCase {
	protected $di;
	protected function setUp() {
		$this->di = new FactoryDefault();
		$this->di->set('db',function() {
			return new Sqlite(__DIR__.'/data.sqlite');
		});
	}

	public function testSubItemIsCreated() {
		$factory = new ItemFactory($this->di);
		$this->assertInstanceOf('SubItem',$factory->getNew('SubItem'));
	}
}
