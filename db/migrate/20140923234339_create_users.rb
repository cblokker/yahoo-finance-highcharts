class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :email
      t.integer :password_digest
      t.float :cash_available
      t.float :cash_invested
      t.float :cash_total

      t.timestamps
    end
  end
end
