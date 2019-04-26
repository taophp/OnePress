namespace OnePress;

use Phalcon\DiInterface;

class opObject {
	protected $di;

	public function __construct(<DiInterface> $di) {
		let this->$di = $di;
	}

}
