namespace OnePress\Db\Models;

use Phalcon\Mvc\Model;

class ItemModel extends Model {
	protected $id;

	public function getId() {
		return $this->id;
	}

	public function initialize() {
		$this->setSource("Items");
	}

	protected function beforeValidationOnCreate() {
		  var $random;
		  let $random = new \Phalcon\Security\Random();
			let $this->id =$random->uuid();
	}
}
