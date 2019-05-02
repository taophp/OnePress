namespace OnePress\Db;

use onePress\opObject;
use Phalcon\Mvc\Model\Query;

class Item extends opObject {
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

	public function __construct(<DiInterface> $di, const string! $id = null) {
		/** @todo ensure that the call was made by ItemFactory */
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
			$random = new \Phalcon\Security\Random();
			let $this->id =$random->uuid();
			let $this->saved = false;
		}else{
			let $this->id =$id;
			let $this->saved = true;
		}
		if (!$this->saved) {
			let $classes = self::getParents();
			let $sql = "SELECT * FROM Item ";
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
	}

	public function __destruct() {
		if (!$this->saved) {
			$this->save();
		}
	}

	public function save() -> void {
		/** @todo what if the object is edited by another user at the same time ? */
		var $parent, $dbFields,$query,$result,$bindParams,$field;
		string $sql;
		var $sqlUpdateParts = [];
		var $parentsDbFields = $this->getParentsDbFields();

		let $bindParams = get_object_vars($this);

		/** @todo to optimize : update only the tables where changes occured */
		for $parent,$dbFields in $parentsDbFields {
			let $sql = "UPDATE ".$parent." SET ";
			for $field in $dbFields {
				let $sqlUpdateParts[] = $parent.".".$field." = :".$field.":";
			}
			let $sql.=implode(", ",$sqlUpdateParts);

			let $query = new Query($sql,$this->di);
			let $result = $query->execute($bindParams);
			/** @todo manage errors */
		}
	}

	public function getParentsDbFields() -> array {
		var $parent;
		array $parentsDbFields =[];
		var $parents = Item::getParents();

		for $parent in $parents {
			let $parentsDbFields[$parent] = {$parent}::getDbFields();
			if ($parent=== __CLASS__) {
				break;
			}
		}
		return $parentsDbFields;

	}

	public static function getDbFields() -> array {
		return self::$dbFields;
	}

	public static function getParents() -> array {
		array $classes = [];
		var $class;

		let $class = get_class();
		while ($class !== false) {
			let $classes[] = $class;
			let $class = get_parent_class($class);
		}
		return $classes;
	}
}
