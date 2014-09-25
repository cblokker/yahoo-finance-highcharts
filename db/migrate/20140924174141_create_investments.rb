class CreateInvestments < ActiveRecord::Migration
  def change
    create_table :investments do |t|
      t.belongs_to :user
      t.belongs_to :stock
      t.float :value
      t.float :percent_change
      t.integer :number_of_shares

      t.timestamps
    end
  end
end
