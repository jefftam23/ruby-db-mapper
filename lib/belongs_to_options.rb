require_relative 'assoc_options'

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    defaults = {
      foreign_key: "#{name.to_s.underscore}_id".to_sym,
      class_name: name.to_s.camelcase,
      primary_key: :id
    }

    options = defaults.merge(options)

    options.each { |attr_name, attr_val| self.send("#{attr_name}=", attr_val) }
  end
end
