namespace OnePress\Db;

use Phalcon\DiInterface;

class ItemFactory {
	protected $di;

	public function __construct(<DiInterface> $di)
	{
		let $this->di = $di;
	}

	public function getById(const string! $id)
	{
		var $item,$class;

		let $item = Items::findFirst(["tableoid::regclass": $id]);
		let $class = $item->{"tableoid::regclass"};

		return new {$class}($id);
	}

	public function getNew(const string $class, string $name = null)
	{
		var $item;

		if (empty($name)) {
			let $name = "New ".$class;
		}

		if unlikely ($class !== "OnePress\\Db\\Items" && !is_subclass_of($class,"OnePress\\Db\\Items")) {
			throw "Class ".$class." is not a subclass of OnePress\Db\Items !";
		}

		let $item = new {$class}();
		$item->pg_create(["display_name":$name]);

		return $item;
	}

	public static function getTableNameFromClassName(const string $class) -> string
	{
		return strtolower(substr($class,strrpos($class,"\\")+1));
	}
}
