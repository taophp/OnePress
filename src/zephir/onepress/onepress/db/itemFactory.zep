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
		if unlikely ($class !== "OnePress\\Db\\Items" && !is_subclass_of($class,"OnePress\\Db\\Items")) {
			throw "Class ".$class." is not a subclass of OnePress\Db\Items !";
		}
		return new {$class}();
	}
}
