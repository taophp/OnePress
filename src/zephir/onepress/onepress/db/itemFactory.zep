namespace OnePress\Db;

use Phalcon\DiInterface;

class ItemFactory
{
	protected $di;
	protected $count;

	public function __construct(<DiInterface> $di)
	{
		let $this->di = $di;
	}

	public function getByUid(const string! $uid)
	{
		var $db,$sql,$result,$rows,$class,$item;

		let $db = $this->di["db"];

		let $sql = "SELECT tableoid::regclass AS class FROM items WHERE uid = ? LIMIT 1";
		let $result = $db->query($sql,[$uid]);

		if unlikely $result === false
		{
			/**
			 * @todo get error message from PDO
			 */
			throw "Failed to get item '".$uid."' from database!\n,Query :".print_r($sql,true);
		}

		let $rows = $result->fetchAll(2); // PDO::FETCH_ASSOC == 2, but we cannot use this constante here !
		if unlikely $rows === false
		{
			/**
			 * @todo get error message from PDO
			 */
			throw "Failed to get data from database when inserting item!\n,Query :".print_r($sql,true);
		}
		let $class = static::getClassNameFromTableName($rows[0]["class"]);

		if !class_exists($class)
		{
			let $class = "OnePress\\Db\\".$class;
		}

		let $item = new {$class}();
		$item->pgGetByUid($uid,$this->di);

		return $item;
	}

	public function getNew(const string! $class, string $name = null)
	{
		var $item;

		if (empty($name)) {
			let $name = "New ".substr($class,0,-1)."-".uniqid();
		}

		if unlikely !is_a($class,"OnePress\\Db\\Items",true) {
			throw "Class ".$class." is not a subclass of OnePress\Db\Items !";
		}

		let $item = new {$class}();
		$item->pgCreate(["display_name":$name],$this->di);

		return $item;
	}

	public static function getTableNameFromClassName(const string $class) -> string
	{
		return strtolower(substr($class,strrpos($class,"\\")+1));
	}

	public static function getClassNameFromTableName(const string $table) -> string
	{
		var $parts,k,$part;

		let $parts = explode("_",$table);
		for k,$part in $parts {
			let $parts[k] = ucfirst($part);
		}

		return implode("",$parts);
	}

	public function findFirst(var $parameters = null) -> <ModelInterface> | bool
	{
		var $item;

		let $item = Items::findFirst($parameters);
		return $this->getByUid($item->uid);
	}
}
