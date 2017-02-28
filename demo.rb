require_relative 'lib/sql_object'

class Dog < SQLObject
  finalize!

  belongs_to :owner,
    class_name: 'Human'

  has_one_through :home, :owner, :house
end

class Human  < SQLObject
  self.table_name = 'humans'
  finalize!

  belongs_to :house

  has_many :dogs,
    foreign_key: :owner_id
end

class House  < SQLObject
  finalize!

  has_many :residents,
    class_name: 'Human'
end
