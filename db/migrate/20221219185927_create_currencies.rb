class CreateCurrencies < ActiveRecord::Migration[7.0]
  def change
    create_table :currencies, id: false, primary_key: :code do |t|
      t.string :code, null: false
      t.string :desc, null: false
      # t.timestamps

      t.index :code, unique: true
    end
  end
end
