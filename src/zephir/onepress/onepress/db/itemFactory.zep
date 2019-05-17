namespace OnePress\Db;

use Phalcon\DiInterface;

class ItemFactory {
	protected $di;

	public function __construct(<DiInterface> $di) {
		let $this->di = $di;
	}

	public function getById(string! $id) {
		var $item,$class;

		let $item = Items::findFirst(["tableoid::regclass": $id]);
		let $class = $item->{"tableoid::regclass"};

		return new {$class}($id);
	}

	public function getNew(string $class, string $name = null) {
		var $tableName,$db,$item;

		if (empty($name)) {
			let $name = "New ".$class;
		}

		if unlikely ($class !== "OnePress\\Db\\Items" && !is_subclass_of($class,"OnePress\\Db\\Items")) {
			throw "Class ".$class." is not a subclass of OnePress\Db\Items !";
		}

		let $item = new {$class}();
		$item->create(["displayName":$name]);

		return $item;
	}

	public static function getTableNameFromClassName(string $class) {
		return strtolower(substr($class,strrpos($class,"\\")+1));
	}
}
