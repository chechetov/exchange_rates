class CreateRates < ActiveRecord::Migration[7.0]
  def change
    create_table :rates, :id => false do |t|
      t.date :date, null: false, :default => DateTime.now.to_fs(:number)
      t.decimal :rate, null: false, :precision => 20, :scale => 10

      t.string :base, null: false
      t.string :to, null: false

      #t.references :base, null: false
      #t.references :to, null: false

      # t.timestamps
    end
    add_foreign_key :rates, :currencies, :name => "base", :column => :base, :primary_key => :code, :on_delete => :cascade
    add_foreign_key :rates, :currencies, :name => "to", :column => :to, :primary_key => :code, :on_delete => :cascade

    #add_foreign_key :rates, :currencies, name: "base", column: :base, primary_key: :code
    #add_foreign_key :rates, :currencies, name: "to", column: :to, primary_key: :code

  end
end
