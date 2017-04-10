
class Category < ActiveRecord::Base
  has_many :gameplans

  self.table_name = "categories"
end