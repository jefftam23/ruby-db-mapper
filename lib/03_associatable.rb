require_relative '02_searchable'
require 'active_support/inflector'

# Phase IIIa
class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    self.class_name.constantize
  end

  def table_name
    self.class_name.downcase == 'human' ? 'humans' : self.class_name.tableize
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    defaults = {
      foreign_key: "#{name.to_s.singularize.underscore}_id".to_sym,
      class_name: name.to_s.singularize.camelcase,
      primary_key: :id
    }

    options = defaults.merge(options)

    options.each { |attr_name, attr_val| send("#{attr_name}=", attr_val) }
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    defaults = {
      foreign_key: "#{self_class_name.to_s.underscore}_id".to_sym,
      class_name: name.to_s.singularize.camelcase,
      primary_key: :id
    }

    options = defaults.merge(options)

    options.each { |attr_name, attr_val| send("#{attr_name}=", attr_val) }
  end
end

module Associatable
  # Phase IIIb
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

  def assoc_options
    # Wait to implement this in Phase IVa. Modify `belongs_to`, too.
    @assoc_options ||= {}
  end
end

class SQLObject
  extend Associatable
end
