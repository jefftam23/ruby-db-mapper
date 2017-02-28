require_relative 'db_connection'
require 'active_support/inflector'
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

class SQLObject
  def self.columns
    if @columns.nil?
      all_rows = DBConnection.execute2(<<-SQL)
        SELECT
          *
        FROM
          #{table_name}
      SQL

      column_headers = all_rows.first
      @columns = column_headers.map(&:to_sym)
    else
      @columns
    end
  end

  def self.finalize!
    columns.each do |col_name|
      define_method(col_name) do
        attributes[col_name]
      end

      define_method("#{col_name}=") do |val|
        attributes[col_name] = val
      end
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name || name.to_s.tableize
  end

  def self.all
    all_rows = DBConnection.execute(<<-SQL)
      SELECT
        *
      FROM
        #{table_name}
    SQL

    parse_all(all_rows)
  end

  def self.parse_all(results)
    results.map { |result_params| self.new(result_params) }
  end

  def self.find(id)
    target = DBConnection.execute(<<-SQL, id)
      SELECT
        *
      FROM
        #{table_name}
      WHERE
        #{table_name}.id = ?
    SQL

    return nil if target.empty?

    parse_all(target).first
  end

  def initialize(params = {})
    attr_names = params.keys.map(&:to_sym)

    attr_names.each do |attr_name|
      unless self.class.columns.include?(attr_name)
        raise "unknown attribute '#{attr_name}'"
      end
    end

    params.each do |attr_name, attr_val|
      send("#{attr_name}=", attr_val)
    end

  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    self.class.columns.map { |attr_name| send(attr_name) }
  end

  def insert
    col_names = self.class.columns.join(", ")
    question_marks = (["?"] * self.class.columns.length).join(", ")

    DBConnection.execute(<<-SQL, *attribute_values)
      INSERT INTO
        #{self.class.table_name} (#{col_names})
      VALUES
        (#{question_marks})
    SQL

    self.id = DBConnection.last_insert_row_id

    nil
  end

  def update
    set_str = self.class.columns.map { |attr_name| "#{attr_name} = ?" }.join(", ")

    DBConnection.execute(<<-SQL, *attribute_values, id)
      UPDATE
        #{self.class.table_name}
      SET
        #{set_str}
      WHERE
        id = ?
    SQL

    nil
  end

  def save
    (id.nil?) ? insert : update
  end
end
