namespace OnePress\Db;

use OnePress\opObject;

class Item extends opObject {

	public function __destruct() {
		if (!$this->saved) {
			$this->save();
		}
	}

	public function save() -> void {
		/** @todo */
	}

}
