class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.string :type
      t.integer :number_of_shares
      t.float :price_per_share
      t.float :total
      t.belongs_to :investment

      t.timestamps
    end
  end
end
