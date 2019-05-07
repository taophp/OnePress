namespace OnePress\Db;

class ItemFactory {
	protected static $registry = [];

	public function getById(string! $id) {
		var $item,$class;

		let $item = Items::findFirst(["tableoid::regclass": $id]);
		let $class = $item->{"tableoid::regclass"};

		return new {$class}($id);
	}

	public function getNew(string! $class) {
		if unlikely ($class !== "Items" && !is_subclass_of($class,"Items")) {
			throw "Class ".$class." is not a subclass of Items !";
		}
		return new {$class}();
	}
}
