# Coding standards

## Objects extending from `OnePress\db\Items`

Those objects are stored in Postgresql database, which has its own naming sheme.
In particular, all table and field names are lower case. This is not the way
PHP used us to. We have decided to allow PHP coders to continue their way
using some naming conventions the feel the gap.

### Classe names

**_Rules_**

* Classes extending from `OnePress\db\Items` MUST be named using _CamelCase_,
starting with a upper letter.
* Classes extending from `OnePress\db\Items` MUST NOT contain any _underscore_ `_`.

```php
class SubItems extends Items {} # This class is correctly named and stored in the table `sub_items`

class sub_sub_item {} # This one, not

class subSubSubSubItem {} # Nor this one
```

### Property names

**_Rules_**

* Properties of classes extending from `OnePress\db\Items` MUST be named using _CamelCase_,
starting with a upper letter, **when they are not stored in database.
* Properties of classes extending from `OnePress\db\Items` MUST be named using _snake_case_,
starting with a lower letter, **when they are stored in database**.
* Properties of classes extending from `OnePress\db\Items` MUST NOT contain any _underscore_ `_`.

```php
class SubItems extends Items {
	protected $stored_property; // property stored in the field `stored_property`
	protected $UnstoredProperty; // property not stored in database
	protected $Mal_formed_property; // don't do this !
	protected $anotherMalFormedProperty; // this neither !
}

```

### Table names

@todo

### Fields names

@todo
