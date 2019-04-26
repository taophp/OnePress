namespace OnePress\DB;

use onePress\opObject;

class ItemFactory extends opObject {
	public function getById(string! $id) {
		var $class;
		var $item;
		let $class = Item::getClassFromId($this->di,$id);

		let $item = new {$class}($this->di,$id);
	}
}
