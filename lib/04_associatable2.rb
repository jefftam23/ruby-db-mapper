require_relative '03_associatable'

# Phase IV
module Associatable
  # Remember to go back to 04_associatable to write ::assoc_options

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

      # A method that requires 2 queries as opposed to 1:
      # send(through_name).send(source_name)
    end
  end
end
