require_relative 'assoc_options'

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    defaults = {
      foreign_key: "#{self_class_name.to_s.underscore}_id".to_sym,
      class_name: name.to_s.singularize.camelcase,
      primary_key: :id
    }

    options = defaults.merge(options)

    options.each { |attr_name, attr_val| self.send("#{attr_name}=", attr_val) }
  end
end
