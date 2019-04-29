namespace OnePress\Db;

use onePress\opObject;
use Phalcon\Mvc\Model\Query;

abstract class Item extends opObject {
	protected $di;
	protected $id;
	protected $saved;
	protected static $dbFields = ["id","class"];

	public static function getClassFromId(<DiInterface> $di, const string! $id) -> string {
		string $sql;
		array $bindParams;
		var $query;
		var $results;
		var $result;
		var $class;

		let $sql = "SELECT classname FROM Items WHERE id = :id:";
		let $bindParams["id"] = $id;
		let $query = new Query($sql,$di);
		let $results = $query->execute($bindParams);

		let $result = $results[0];
		let $class = $result->classname;

		return $class;
	}

	protected static final function getNewId() -> string {
		var $id;
		/** @see https://stackoverflow.com/questions/2040240/php-function-to-generate-v4-uuid#answer-2040279 */
		let $id = sprintf( "%04x%04x-%04x-%04x-%04x-%04x%04x%04x",
			// 32 bits for "time_low"
			mt_rand( 0, 0xffff ), mt_rand( 0, 0xffff ),

			// 16 bits for "time_mid"
			mt_rand( 0, 0xffff ),

			// 16 bits for "time_hi_and_version",
			// four most significant bits holds version number 4
			mt_rand( 0, 0x0fff ) | 0x4000,

			// 16 bits, 8 bits for "clk_seq_hi_res",
			// 8 bits for "clk_seq_low",
			// two most significant bits holds zero and one for variant DCE1.1
			mt_rand( 0, 0x3fff ) | 0x8000,

			// 48 bits for "node"
			mt_rand( 0, 0xffff ), mt_rand( 0, 0xffff ), mt_rand( 0, 0xffff )
		);
		return $id;
	}

	public function __construct(<DiInterface> $di, const string! $id = null) {
		var $classes;
		string $sql;
		var $class;
		let $this->di = $di;
		var $query;
		var $results;
		var $result;
		array $bindParams;
		var $properties;
		var $property;

		if (empty $id) {
			let $this->id =self::getNewId();
			let $this->saved = false;
		}else{
			let $this->id =$id;
			let $this->saved = true;
		}
		if ($this->saved) {
			let $classes = self::getParents();
		}
		let $sql = "SELECT * FROM Items ";
		for $class in $classes {
			let $sql.= " LEFT JOIN ".$class." ON Item.id = ".$class.".id ";
		}
		let $sql.=" WHERE Items.id = :id:";

		let $query = new Query($sql,$di);
		let $bindParams["id"] = $id;
		let $results = $query->execute($bindParams);
		let $result = $results[0];

		let $properties = get_object_vars($result);
		for $property in $properties {
			let $this->{$property} = $result->{$property};
		}
	}

	public function __destruct() {
		if (!$this->saved) {
			$this->save();
		}
	}

	public function save() {
	}

	public function getParentsDbFields() -> array {
		var $parents;
		var $parent;
		array $parentsDbFields;
		let $parents = Item::getParents();

		for $parent in $parents {
			let $parentsDbFields[$parent] = {$parent}::getDbFields();
		}
		return $parentsDbFields;

	}
	public static function getDbFields() -> array {
		return self::$dbFields;
	}
	public static function getParents() -> array {
		array $classes;
		var $class;

		let $class = get_class();
		while ($class !== false) {
			let $classes[] = $class;
			let $class = get_parent_class($class);
		}
		return $classes;
	}
}
