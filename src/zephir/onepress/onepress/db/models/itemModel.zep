namespace OnePress\Db\Models;

use Phalcon\Mvc\Model;

class ItemModel extends Model {
	public function initialize() {
		$this->setSource("Items");
	}
}
