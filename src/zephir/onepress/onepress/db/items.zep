namespace OnePress\Db;

use Phalcon\Mvc\Model;

class Items extends Model {
	const FACTORY_CLASS = "OnePress\\Db\\ItemFactory";
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
