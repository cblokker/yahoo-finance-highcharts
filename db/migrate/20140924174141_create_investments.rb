class CreateInvestments < ActiveRecord::Migration
  def change
    create_table :investments do |t|
      t.belongs_to :user
      t.belongs_to :stock
      t.float :number_of_shares
      t.float :value

      t.timestamps
    end
  end
end
