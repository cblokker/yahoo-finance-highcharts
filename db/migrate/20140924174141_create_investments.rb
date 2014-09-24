class CreateInvestments < ActiveRecord::Migration
  def change
    create_table :investments do |t|
      t.belongs_to :user
      t.belongs_to :stock
      t.float :percent_change

      t.timestamps
    end
  end
end
