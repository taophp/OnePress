namespace OnePress\Db;

use Phalcon\Mvc\Model;
use Phalcon\Db\Column;
use Phalcon\Mvc\Model\MetaData;
use Phalcon\DiInterface;

class Items extends Model {
	protected $_settable = NULL;
	protected $uid {
		get, toString
	};
	public $displayName;

	public function initialize()
	{
		$this->useDynamicUpdate(true);
	}

	/**
	 * @see https://forum.phalconphp.com/discussion/8397/return-primary-key-after-createsave
	 * @todo optimize "à la" zephir
	 */
	public function pgCreate(const array $data,<DiInterface> $di) -> bool
	{
		var $table,$db,$fields,$columns,$d,$fieldNames,$fieldValues,$qs,$sql,$result,$rows,$column;
		let $table = $this->getSource();
		let $db = $di->get("db");

		let $fields = [];
		if ($this->_settable && is_array($this->_settable)) {
			let $fields = $this->_settable;
		} else {
			let $columns = $db->describeColumns($table);
			for $column in $columns {
				let $fields[] = $column->getName();
			}
		}
		let $d = array_intersect_key($data, array_flip($fields));

		let $fieldNames = implode(',', array_keys($d));
		let $fieldValues = array_values($d);

		let $qs = str_repeat("?,", count($fieldValues) - 1) . "?";

		let $sql = "INSERT INTO ".$table." (".$fieldNames.") VALUES (".$qs.") RETURNING *";
		let $result = $db->query($sql, $fieldValues);
		if unlikely $result === false
		{
			/**
			 * @todo get error message from PDO
			 */
			throw "Failed to insert item in database!\n,Query :".print_r($sql,true);
		}
		let $rows = $result->fetchAll(2); // PDO::FETCH_ASSOC == 2, but we cannot use this constante here !
		if ($rows === false)
		{
			/**
			 * @todo get error message from PDO
			 */
			throw "Failed to get data from database when inserting item!\n,Query :".print_r($sql,true);
		}

		$this->assign($rows[0]);
		return true;
	}

	public function pgGetByUid(const string! $uid,<DiInterface> $di) {
		var $table,$db,$sql,$result,$rows;

		let $table = $this->getSource();
		let $db = $di->get("db");

		let $sql = "SELECT * FROM items WHERE uid = ? LIMIT 1";
		let $result = $db->query($sql,[$uid]);

		if unlikely $result === false
		{
			/**
			 * @todo get error message from PDO
			 */
			throw "Failed to get item '".$uid."from database!\n,Query :".print_r($sql,true);
		}

		let $rows = $result->fetchAll(2); // PDO::FETCH_ASSOC == 2, but we cannot use this constante here !
		if ($rows === false)
		{
			/**
			 * @todo get error message from PDO
			 */
			throw "Failed to get data from database when inserting item!\n,Query :".print_r($sql,true);
		}

		$this->assign($rows[0]);
		return true;
	}
}
