namespace OnePress\Db;

use Phalcon\Mvc\Model;

class Items extends Model {
	protected $id {
		get, toString
	};

	public function initialize() {
		$this->useDynamicUpdate(true);
	}

	protected function __destruct() {
		$this->save();
	}
}
