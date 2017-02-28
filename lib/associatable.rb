require 'byebug'

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
      foreign_key_col_name = options.foreign_key
      foreign_key_val = self.send(foreign_key_col_name)
      options.model_class.where(id: foreign_key_val).first
    end
  end

  def has_many(name, options = {})
    options = HasManyOptions.new(name, self.to_s, options)
    assoc_options[name] = options

    define_method(name) do
      foreign_key_col_name = options.foreign_key
      options.model_class.where(foreign_key_col_name => self.id)
    end
  end

  def has_one_through(name, through_name, source_name)
    define_method(name) do
      through_obj = self.send(through_name)
      through_options = self.class.assoc_options[through_name]
      source_options = through_obj.class.assoc_options[source_name]
      source_arr = self.class
        .send(:source_query, through_options, source_options, through_obj.id)
      source_options.model_class.new(source_arr.first)
    end
  end

  private

  def source_query(through_options, source_options, through_obj_id)
    through_table = through_options.table_name
    source_table = source_options.table_name

    DBConnection.execute(<<-SQL, through_obj_id)
      SELECT
        #{source_table}.*
      FROM
        #{source_table}
      JOIN
        #{through_table}
      ON
        #{through_table}.#{source_options.foreign_key} = #{source_table}.id
      WHERE
        #{through_table}.id = ?
    SQL
  end
end
