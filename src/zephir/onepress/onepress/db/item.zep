namespace OnePress\DB;

use onePress\opObject;
use Phalcon\Mvc\Model\Query;

abstract class Item extends opObject {
	protected $di;
	protected $id;

	public static function getClassFromId(<DiInterface> $di, const string! $id) -> string {
		string $sql;
		var $query;
		let $sql = "SELECT class FROM Items WHERE id = :id:";
		let $query = new Query($sql,$di);

		return "";
	}

	protected static function getNewId() -> string {
		var $id;
		/** @see https://stackoverflow.com/questions/2040240/php-function-to-generate-v4-uuid#answer-2040279 */
		let $id = sprintf( "%04x%04x-%04x-%04x-%04x-%04x%04x%04x",
			// 32 bits for "time_low"
			mt_rand( 0, 0xffff ), mt_rand( 0, 0xffff ),

			// 16 bits for "time_mid"
			mt_rand( 0, 0xffff ),

			// 16 bits for "time_hi_and_version",
			// four most significant bits holds version number 4
			mt_rand( 0, 0x0fff ) | 0x4000,

			// 16 bits, 8 bits for "clk_seq_hi_res",
			// 8 bits for "clk_seq_low",
			// two most significant bits holds zero and one for variant DCE1.1
			mt_rand( 0, 0x3fff ) | 0x8000,

			// 48 bits for "node"
			mt_rand( 0, 0xffff ), mt_rand( 0, 0xffff ), mt_rand( 0, 0xffff )
		);
		return $id;
	}

	public function __construct(<DiInterface> $di, const string! $id = null) {
		let $this->di = $di;
		let $this->id = $id;
	}
}
