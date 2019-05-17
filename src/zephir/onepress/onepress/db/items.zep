namespace OnePress\Db;

use Phalcon\Mvc\Model;
use Phalcon\Db\Column;
use Phalcon\Mvc\Model\MetaData;

class Items extends Model {
	protected $_settable = NULL;
	protected $id {
		get, toString
	};


	public function initialize() {
		$this->useDynamicUpdate(true);
	}

	public function __destruct() {
		$this->save();
	}

			/**
		 * @see https://forum.phalconphp.com/discussion/8397/return-primary-key-after-createsave
		 * @todo debug, optimize "à la" zephir
		 */
		public function create($data) {
		var $table,$di,$db,$fields,$columns,$d,$fieldNames,$fieldValues,$qs,$sql,$result,$rows,$column;

				let $table = $this->getSource();

				let $di = \Phalcon\DI::getDefault();
				let $db = $di["db"];

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

				let $sql = "INSERT INTO {$table} ({$fieldNames}) VALUES ({$qs}) RETURNING *";
		let $result = $db->query($sql, $fieldValues);
				if ($result === false) {return false;}
				let $rows = $result->fetchAll(2);
				if ($rows === false) {return false;}

				$this->assign($rows[0]);
				return true;
		}
}
