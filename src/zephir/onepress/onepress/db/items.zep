namespace OnePress\Db;

use Phalcon\Mvc\Model;
use Phalcon\Db\Column;
use Phalcon\Mvc\Model\MetaData;

class Items extends Model {
	protected $id {
		get, toString
	};

	public function initialize() {
		$this->useDynamicUpdate(true);
	}

	public function __destruct() {
		$this->save();
	}
}
