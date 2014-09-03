class CreateQuotes < ActiveRecord::Migration
  def change
    create_table :quotes do |t|
      t.string :trade_date
      t.string :open
      t.string :high
      t.string :low
      t.string :close
      t.string :volume
      t.string :adjusted_close
      t.belongs_to :stock

      t.timestamps
    end
  end
end
