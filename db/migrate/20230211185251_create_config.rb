class CreateConfig < ActiveRecord::Migration[7.0]
  def change
    create_table :configs do |t|
      t.string :url
      t.string :apikey
    end
  end
end
