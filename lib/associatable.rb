require_relative 'searchable'
require_relative 'belongs_to_options'
require_relative 'has_many_options'

module Associatable
  def assoc_options
    @assoc_options ||= {}
  end

  def belongs_to(name, options = {})
    options = BelongsToOptions.new(name, options)

    assoc_options[name] = options

    define_method(name) do
      # inside an instance of SQLObject
      foreign_key_col_name = options.foreign_key
      foreign_key_val = send(foreign_key_col_name)

      options.model_class.where(id: foreign_key_val).first
    end
  end

  def has_many(name, options = {})
    options = HasManyOptions.new(name, self.to_s, options)

    define_method(name) do
      foreign_key_col_name = options.foreign_key

      options.model_class.where(foreign_key_col_name => self.id)
    end
  end

  def has_one_through(name, through_name, source_name)
    through_options = assoc_options[through_name]

    define_method(name) do
      through_obj_instance = self.send(through_name)

      source_options = through_options.model_class.assoc_options[source_name]

      through_table_name = through_options.model_class.table_name
      source_table_name = source_options.model_class.table_name

      source_arr = DBConnection.execute(<<-SQL, through_obj_instance.id)
        SELECT
          "#{source_table_name}".*
        FROM
          #{source_table_name}
        JOIN
          #{through_table_name}
        ON
          #{through_table_name}.#{source_options.foreign_key} = #{source_table_name}.id
        WHERE
          #{through_table_name}.id = ?
      SQL

      source_obj_params = source_arr.first

      source_options.model_class.new(source_obj_params)
    end
  end
end
