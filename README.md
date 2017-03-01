# ruby-db-mapper

ruby-db-mapper is a lightweight Ruby object-relational mapping (ORM). It provides an interface for database manipulation through Ruby methods and objects.
Such objects are often called **models**. When using the ORM, each Ruby object represents a database record, and the relationships between
objects of different types (another words, records from different database tables) can be defined through **associations**.

## Demo Instructions

## Setup

1. Install the library and move it to the desired location.
1. Navigate to the `lib/db_connection.rb` file and set the `SQL_FILE` and `DB_FILE` to the absolute paths of your SQL and database files.
1. `require` the `ruby_db_mapper.rb` file in each model class definition file.
1. Ensure the model class inherits from `SQLObject` and that the class name is the singular and `ProudCamelCase` version
of the corresponding database table name. <br />**NOTE:** ruby-db-mapper uses naming conventions to determine which database table a model class corresponds to.
By default, the library utilizes `active_support/inflector` to pluralize and convert the class name to `snake_case`.
If you need to override the default, do so in the class definition with the `SQLObject::table_name=` method (see the `Human` class from `demo.rb` for an example).

## `SQLObject` API

### Database Querying and Manipulation

#### `::all`

#### `::find(id)`

#### `#save`

#### `#where(params)`

### Associations

#### `#belongs_to(name, options = {})`

#### `#has_many(name, options = {})`

#### `#has_one_through(name, through_name, source_name)`

## Future Work
