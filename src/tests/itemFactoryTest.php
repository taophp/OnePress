<?php
use PHPUnit\Framework\TestCase;
use OnePress\Db\Item;
use OnePress\Db\ItemFactory;

class SubItem extends Item {}
class SubSubItem extends SubItem {}


class ItemFactoryTest extends TestCase {
	public function testSubItemIsCreated() {
		$factory = new ItemFactory();
		$this->assertInstanceOf('SubItem',$factory->getNew($this->di,'SubItem'));
	}
}
