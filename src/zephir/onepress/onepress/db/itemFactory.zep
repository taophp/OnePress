namespace OnePress\Db;

use onePress\opObject;

class ItemFactory extends opObject {
	protected $registery = [];

	public function getById(string! $id) {
		if (array_key_exists($id,ItemFactory::$registry) {
			return ItemFactory::$registery;
		}
		var $class;
		var $item;
		let $class = Item::getClassFromId($this->di,$id);

		let $item = new {$class}($this->di,$id);

		let ItemFactory::registery[$id] = $item;

		return $item;
	}
}
