namespace OnePress\Db;

use onePress\opObject;

class ItemFactory extends opObject {
	protected static $registry = [];
	protected $di;

	public function getById(string! $id) {
		if (array_key_exists($id,self::$registry)) {
			return ItemFactory::$registry;
		}
		var $class;
		var $item;
		let $class = Item::getClassFromId($this->di,$id);

		let $item = new {$class}($this->di,$id);

		let ItemFactory::$registry[$id] = $item;

		return $item;
	}

	public function getNew(string! $class) {
		var $item;
		if unlikely !is_subclass_of($class,"\Onepress\Db\Item") {
			echo "\nClass:".$class."\n";
			return null;
			/** @todo throw Exception */
		}
		let $item = new {$class}($this->di);

		let ItemFactory::$registry[$item->id] = $item;

		return $item;

	}
}
