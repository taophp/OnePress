<?php
declare(strict_types=1);

use PHPUnit\Framework\TestCase;
use OnePress\Db\Item;
use OnePress\Db\ItemFactory;

class SubItem extends Item {}
class SubSubItem extends SubItem {}


class ItemFactoryTest extends TestCase {
	protected $di;
	protected function setUp() {
		$this->di = new FactoryDefault();
	}

	public function testSubItemIsCreated() {
		$factory = new ItemFactory($this->di);
		$this->assertInstanceOf('SubItem',$factory->getNew($this->di,'SubItem'));
	}
}
