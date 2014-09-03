class Stock < ActiveRecord::Base
  has_many :quotes
end
