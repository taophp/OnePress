namespace OnePress\DB;

use onePress\opObject;
use Phalcon\Mvc\Model\Query;

abstract class Item extends opObject {
	protected $di;

	public static function getClassFromId(<DiInterface> $di, const string! $id) -> string {
		string $sql;
		var $query;
		let $sql = "SELECT class FROM Items WHERE id = :id:";
		let $query = new Query($sql,$di);

		return "";
	}

	public function __construct(<DiInterface> $di, const string! $id = null) {
		let $this->di = $di;
	}
}
