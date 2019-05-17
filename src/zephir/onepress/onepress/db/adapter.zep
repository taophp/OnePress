namespace OnePress\Db;

use Phalcon\Db\Adapter\Pdo\Postgresql;

/**
 * @see https://forum.phalconphp.com/discussion/8397/return-primary-key-after-createsave#C45221
 */

class Adapter extends Postgresql {
	protected lastInsertIdValue;
	protected tablesUsingUuid = [];
	protected lastInsertHere;

	/**
	 * @see https://github.com/phalcon/cphalcon/blob/master/phalcon/db/adapter.zep
	 */
	public function insert(table, array! values, var fields = null, var dataTypes = null) -> bool {
		if (!array_key_exists(table,$this->tablesUsingUuid)) {
			let $this->lastInsertHere = parent::insert(table,values,fields,dataTypes);
			return $this->lastInsertHere;
		}else{
			var placeholders, insertValues, bindDataTypes, bindType,
				position, value, escapedTable, joinedValues, escapedFields,
				field, insertSql;

			/**
			 * A valid array with more than one element is required
			 */
			if !count(values) {
				throw new \Phalcon\Db\Exception("Unable to insert into " . table . " without data");
			}

			let placeholders = [],
				insertValues = [];

			let bindDataTypes = [];

			/**
			 * Objects are casted using __toString, null values are converted to string "null", everything else is passed as "?"
			 */
			for position, value in values {
				if typeof value == "object" && value instanceof RawValue {
					let placeholders[] = (string) value;
				} else {
					if typeof value == "object" {
						let value = (string) value;
					}
					if typeof value == "null" {
						let placeholders[] = "null";
					} else {
						let placeholders[] = "?";
						let insertValues[] = value;
						if typeof dataTypes == "array" {
							if !fetch bindType, dataTypes[position] {
								throw new \Phalcon\Db\Exception("Incomplete number of bind types");
							}
							let bindDataTypes[] = bindType;
						}
					}
				}
			}

			let escapedTable = this->escapeIdentifier(table);

			/**
			 * Build the final SQL INSERT statement
			 */
			let joinedValues = join(", ", placeholders);
			if typeof fields == "array" {
				let escapedFields = [];
				for field in fields {
					let escapedFields[] = this->escapeIdentifier(field);
				}

				let insertSql = "INSERT INTO " . escapedTable . " (" . join(", ", escapedFields) . ") VALUES (" . joinedValues . ")";
			} else {
				let insertSql = "INSERT INTO " . escapedTable . " VALUES (" . joinedValues . ")";
			}

			let insertSql.="  RETURNING ".$this->tablesUsingUuid[table];
file_put_contents("my.log","\n".insertSql."\n");

			/**
			 * Perform the execution via PDO::execute
			 */
			if !count(bindDataTypes) {
				return this->{"execute"}(insertSql, insertValues);
			}

			return this->{"execute"}(insertSql, insertValues, bindDataTypes);
		}
		return false;
	}

	/**
	 * @see https://github.com/phalcon/cphalcon/blob/master/phalcon/db/adapter/pdo.zep
	 */
	 public function lastInsertId(sequenceName = null) -> string | int | bool {
			return $this->lastInsertHere
			? $this->lastInsertIdValue
			: parent::lastInsertId(sequenceName);
	}

	public function registerTableUsingUuid(string table, string uuidColumn = "id") {
		let this->tablesUsingUuid[table] = uuidColumn;
	}
}
