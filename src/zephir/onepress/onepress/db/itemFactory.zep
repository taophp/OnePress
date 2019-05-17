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

	public function getNew(string! $class) {
		var $tableName,$db;

		if unlikely ($class !== "OnePress\\Db\\Items" && !is_subclass_of($class,"OnePress\\Db\\Items")) {
			throw "Class ".$class." is not a subclass of OnePress\Db\Items !";
		}

		let $tableName = static::getTableNameFromClassName($class);
		let $db = $this->di->get("db");
		$db->registerTableUsingUuid($tableName);

		return new {$class}();
	}

	public static function getTableNameFromClassName(string $class) {
		return strtolower(substr($class,strrpos($class,"\\")+1));
	}
}
