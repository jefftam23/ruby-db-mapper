# rubyDBmapper

rubyDBmapper is a lightweight Ruby object-relational mapping (ORM). It provides an interface for database manipulation through Ruby methods and objects.
Such objects are often called **models**. When using the ORM, each Ruby object represents a database record, and the relationships between
objects of different types (another words, records from different database tables) can be defined through **associations**.

## Demo Instructions

## Setup

1. Install the library and move it to the desired location.
1. Navigate to the `lib/db_connection.rb` file and set the `SQL_FILE` and `DB_FILE` to the absolute paths of your SQL and database files.
1. `require` the `ruby_db_mapper.rb` file in each model class definition file.
1. Ensure the model class inherits from `SQLObject` and that the class name is the singular and `ProudCamelCase` version
of the corresponding database table name. <br />**NOTE:** rubyDBmapper uses naming conventions to determine which database table a model class corresponds to.
By default, the library utilizes `active_support/inflector` to pluralize and convert the class name to `snake_case`.
If you need to override the default, do so in the class definition with the `SQLObject::table_name=` method (see the `Human` class from `demo.rb` for an example).

## `SQLObject` API

### Database Querying and Manipulation

#### `::all`

Returns an array of all Ruby model objects corresponding to a particular database table

#### `::find(id)`

Returns a Ruby model object with the corresponding `id` if it exists and `nil` otherwise

#### `#save`

Persists a new or updated record to the database

#### `#where(params)`

Returns an array of Ruby model objects that satisfy `params`

### Associations

#### `#belongs_to(name, options = {})`

Represents a one-to-one relationship and is used when this particular class contains a foreign key. This method defines an instance method whose name corresponds the value of the `name` parameter. The created instance method returns the associated model.

#### Options

###### `:class_name`

This option should be a string or symbol that corresponds to the class name of the targeted model. By default, this option uses the value of the `name` parameter converted to `CamelCase` (e.g., if `name = "house"` then the default option would be `class_name: "House"`).

###### `:foreign_key`

This option should be a string or symbol that corresponds to the database column name of the foreign key for the association. By default, this option uses the value of the `name` parameter converted to `snake_case` with the string `_id` appended to the end (e.g., if `name = "house"` then the default option would be `foreign_key: :house_id`).

###### `:primary_key`

This option should be a string or symbol that corresponds to the database column name of the primary key for the association. By default, this option uses `:id`.

#### `#has_many(name, options = {})`

Represents a one-to-many relationship and is used when another class contains a foreign key that references this class's primary key. This method defines an instance method whose name corresponds to the value of the `name` parameter. The created instance method returns an array of associated models.

#### Options

###### `:class_name`

This option should be a string or symbol that corresponds to the class name of the targeted model. By default, this option uses the value of the `name` parameter converted to `CamelCase`.

###### `:foreign_key`

This option should be a string or symbol that corresponds to the database column name of the foreign key for the association. By default, this option uses this model's class name converted to `snake_case` with the string `_id` appended to the end.

###### `:primary_key`

This option should be a string or symbol that corresponds to the database column name of the primary key for the association. By default, this option uses `:id`.


#### `#has_one_through(name, through_name, source_name)`

Represents a one-to-one relationship where the current model reaches through an association that it already has (whose name is the string or symbol `through_name`) to create an association that exists in the 'through' model and has a name of `source_name`. This method defines another method with a name corresponding to the value of `name`. In the example below, `Song` reaches through the `Album` it belongs to in order to create a `has_one_through` association with its `Artist`.

```ruby
class Song < SQLObject
  belongs_to :album
  has_one_through :artist, :album, :artist

  finalize!
end

class Album < SQLObject
  belongs_to :artist
  has_many :songs

  finalize!
end

class Artist < SQLObject
  has_many :albums

  finalize!
end
```

## Future Work

1. `has_many_through` association
1. Validation methods
1. `joins` to perform SQL joins
