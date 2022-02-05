class CreateItems < ActiveRecord::Migration[6.0]
  def change
    create_table :items do |t|
      t.string :name
      t.string :code
      t.integer :pack_number
      t.integer :pack_price

      t.timestamps
    end
  end
end
