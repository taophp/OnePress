namespace OnePress\DB;

use onePress\opObject;

class ItemFactory extends opObject {
	public function getById(string! $id) {
		var $class;
		let $class = Item::getClassFromId($id);
	}
}
