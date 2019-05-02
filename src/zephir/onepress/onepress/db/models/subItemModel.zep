namespace OnePress\Db\Models;

use Phalcon\Mvc\Model;

class SubItemModel extends Model {
	public function initialize() {
		$this->setSource("SubItems");
	}

	protected function beforeValidationOnCreate() {
	}
}
