class Investment < ActiveRecord::Base
  belongs_to :user
  belongs_to :stock
  has_many :transactions

end
